import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;
import 'dart:html' as html;
import '../models/user.dart';
import '../models/qr_code.dart';
import '../models/video_call.dart';
import 'package:dio/src/form_data.dart'; // Added FormData import

class ApiService {
  final Dio _dio;
  final SharedPreferences _prefs;
  static const String baseUrl = 'http://localhost:8000';
  static const String apiPrefix = '/api/v1';

  String? get token => _prefs.getString('token');

  ApiService(this._dio, this._prefs) {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 3);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    _dio.options.validateStatus = (status) {
      return status! < 500;
    };

    // Add logging interceptor
    _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (object) {
          developer.log(object.toString(), name: 'API');
        }));

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          developer.log('Request: ${options.method} ${options.path}',
              name: 'API',
              error: {
                'data': options.data,
                'headers': options.headers,
              });

          final token = _prefs.getString('token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          developer.log('Error: ${e.type} - ${e.message}', name: 'API', error: {
            'path': e.requestOptions.path,
            'method': e.requestOptions.method,
            'data': e.requestOptions.data,
            'headers': e.requestOptions.headers,
            'response': e.response?.data,
            'statusCode': e.response?.statusCode,
          });
          if (e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.receiveTimeout) {
            return handler.reject(
              DioException(
                requestOptions: e.requestOptions,
                error:
                    'Connection timed out. Please check your internet connection.',
                type: e.type,
              ),
            );
          }
          if (e.response?.statusCode == 404) {
            return handler.reject(
              DioException(
                requestOptions: e.requestOptions,
                error:
                    'Server not found. Please make sure the backend server is running.',
                type: e.type,
              ),
            );
          }
          return handler.next(e);
        },
      ),
    );
  }

  // Auth
  Future<String> register(String email, String password, String name) async {
    try {
      developer.log('Attempting registration',
          name: 'API', error: {'email': email, 'name': name});

      // Split full name into first and last name
      final nameParts = name.trim().split(' ');
      final firstName = nameParts[0];
      final lastName =
          nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      // Create form data
      final formData = FormData.fromMap({
        'email': email.trim(),
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
      });

      final response = await _dio.post(
        '$apiPrefix/auth/register',
        data: formData,
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      developer.log('Registration response', name: 'API', error: {
        'statusCode': response.statusCode,
        'data': response.data,
      });

      if (response.statusCode == 200) {
        final token = response.data['access_token'];
        await _prefs.setString('token', token);
        return token;
      } else {
        throw Exception('Registration failed: ${response.data['detail']}');
      }
    } on DioException catch (e) {
      developer.log('Registration failed', name: 'API', error: e);
      if (e.response?.data != null && e.response?.data['detail'] != null) {
        throw Exception(e.response?.data['detail']);
      } else {
        throw Exception('Registration failed: ${e.message}');
      }
    } catch (e) {
      developer.log('Registration failed', name: 'API', error: e);
      throw Exception('Registration failed: $e');
    }
  }

  String _handleDioError(DioException e) {
    if (e.response?.statusCode == 409) {
      return 'Email already exists. Please use a different email.';
    }
    if (e.response?.statusCode == 422) {
      final data = e.response?.data;
      developer.log('Validation Error', name: 'API', error: data);
      if (data is Map<String, dynamic> && data.containsKey('detail')) {
        if (data['detail'] is List) {
          // Handle Pydantic validation errors
          final errors = (data['detail'] as List)
              .map((error) => error['msg']?.toString() ?? '')
              .where((msg) => msg.isNotEmpty)
              .join(', ');
          return 'Validation error: $errors';
        }
        return 'Validation error: ${data['detail']}';
      }
      return 'Invalid input data. Please check your input.';
    }
    if (e.response?.statusCode == 400) {
      final data = e.response?.data;
      if (data is Map<String, dynamic> && data.containsKey('detail')) {
        return 'Invalid request: ${data['detail']}';
      }
      return 'Invalid request. Please check your input.';
    }
    if (e.type == DioExceptionType.connectionTimeout) {
      return 'Connection timed out. Please check your internet connection.';
    }
    if (e.type == DioExceptionType.receiveTimeout) {
      return 'Server is taking too long to respond. Please try again.';
    }
    return e.error?.toString() ?? 'Registration failed. Please try again.';
  }

  Future<String> login(String email, String password) async {
    try {
      developer.log('Attempting login', name: 'API', error: {'email': email});

      // Create form data
      final formData = FormData.fromMap({
        'username':
            email.trim(), // OAuth2 form expects 'username' instead of 'email'
        'password': password,
      });

      final response = await _dio.post(
        '$apiPrefix/auth/login',
        data: formData,
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      developer.log('Login successful',
          name: 'API', error: {'statusCode': response.statusCode});

      final token = response.data['access_token'];
      await _prefs.setString('token', token);
      return token;
    } on DioException catch (e) {
      final errorMsg = _handleDioError(e);
      developer.log('Login failed', name: 'API', error: errorMsg);
      throw errorMsg;
    } catch (e) {
      developer.log('Unexpected error during login',
          name: 'API', error: e.toString());
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  Future<void> logout() async {
    try {
      await _prefs.remove('token');
    } on DioException catch (e) {
      final errorMsg = _handleDioError(e);
      developer.log('Logout failed', name: 'API', error: errorMsg);
      throw errorMsg;
    } catch (e) {
      developer.log('Unexpected error during logout',
          name: 'API', error: e.toString());
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // QR Codes
  Future<List<QRCode>> getQRCodes() async {
    try {
      developer.log('Attempting to retrieve QR codes', name: 'API');

      final response = await _dio.get('$apiPrefix/qr-codes/');

      developer.log('QR codes retrieved successfully',
          name: 'API', error: {'statusCode': response.statusCode});

      return (response.data as List)
          .map((json) => QRCode.fromJson(json))
          .toList();
    } on DioException catch (e) {
      final errorMsg = _handleDioError(e);
      developer.log('Failed to retrieve QR codes',
          name: 'API', error: errorMsg);
      throw errorMsg;
    } catch (e) {
      developer.log('Unexpected error during QR code retrieval',
          name: 'API', error: e.toString());
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  Future<QRCode> createQRCode(
      String name, String description, DateTime expiryDate) async {
    try {
      developer.log('Attempting to create QR code',
          name: 'API', error: {'name': name, 'description': description});

      final response = await _dio.post('$apiPrefix/qr-codes/', data: {
        'name': name,
        'description': description,
        'expiry_date': expiryDate.toIso8601String(),
      });

      developer.log('QR code created successfully',
          name: 'API', error: {'statusCode': response.statusCode});

      return QRCode.fromJson(response.data);
    } on DioException catch (e) {
      final errorMsg = _handleDioError(e);
      developer.log('Failed to create QR code', name: 'API', error: errorMsg);
      throw errorMsg;
    } catch (e) {
      developer.log('Unexpected error during QR code creation',
          name: 'API', error: e.toString());
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // Video Calls
  Future<VideoCall> createVideoCall(String qrCodeId) async {
    try {
      developer.log('Attempting to create video call',
          name: 'API', error: {'qrCodeId': qrCodeId});

      final response = await _dio.post('$apiPrefix/video-calls/', data: {
        'qr_code_id': qrCodeId,
      });

      developer.log('Video call created successfully',
          name: 'API', error: {'statusCode': response.statusCode});

      return VideoCall.fromJson(response.data);
    } on DioException catch (e) {
      final errorMsg = _handleDioError(e);
      developer.log('Failed to create video call',
          name: 'API', error: errorMsg);
      throw errorMsg;
    } catch (e) {
      developer.log('Unexpected error during video call creation',
          name: 'API', error: e.toString());
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  Future<List<VideoCall>> getVideoCalls() async {
    try {
      developer.log('Attempting to retrieve video calls', name: 'API');

      final response = await _dio.get('$apiPrefix/video-calls/');

      developer.log('Video calls retrieved successfully',
          name: 'API', error: {'statusCode': response.statusCode});

      return (response.data as List)
          .map((json) => VideoCall.fromJson(json))
          .toList();
    } on DioException catch (e) {
      final errorMsg = _handleDioError(e);
      developer.log('Failed to retrieve video calls',
          name: 'API', error: errorMsg);
      throw errorMsg;
    } catch (e) {
      developer.log('Unexpected error during video call retrieval',
          name: 'API', error: e.toString());
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  Future<void> updateVideoCallStatus(String callId, CallStatus status) async {
    try {
      developer.log('Attempting to update video call status',
          name: 'API', error: {'callId': callId, 'status': status.toString()});

      await _dio.put('$apiPrefix/video-calls/$callId', data: {
        'status': status.toString().split('.').last,
      });

      developer.log('Video call status updated successfully', name: 'API');
    } on DioException catch (e) {
      final errorMsg = _handleDioError(e);
      developer.log('Failed to update video call status',
          name: 'API', error: errorMsg);
      throw errorMsg;
    } catch (e) {
      developer.log('Unexpected error during video call status update',
          name: 'API', error: e.toString());
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // Device Tokens
  Future<void> registerDeviceToken(String token, String deviceType) async {
    try {
      developer.log('Attempting to register device token',
          name: 'API', error: {'token': token, 'deviceType': deviceType});

      await _dio.post('$apiPrefix/device-tokens/', data: {
        'token': token,
        'device_type': deviceType,
      });

      developer.log('Device token registered successfully', name: 'API');
    } on DioException catch (e) {
      final errorMsg = _handleDioError(e);
      developer.log('Failed to register device token',
          name: 'API', error: errorMsg);
      throw errorMsg;
    } catch (e) {
      developer.log('Unexpected error during device token registration',
          name: 'API', error: e.toString());
      throw 'An unexpected error occurred. Please try again.';
    }
  }
}
