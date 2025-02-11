import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class FirebaseService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final ApiService _apiService;
  final SharedPreferences _prefs;

  FirebaseService(this._apiService, this._prefs);

  Future<void> initialize() async {
    // Request permission for notifications
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Configure FCM callbacks
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Get FCM token and register with backend
    final token = await _messaging.getToken();
    if (token != null) {
      final deviceType = _getDeviceType();
      await _apiService.registerDeviceToken(token, deviceType);
      await _prefs.setString('fcm_token', token);
    }

    // Listen for token refresh
    _messaging.onTokenRefresh.listen((newToken) async {
      final deviceType = _getDeviceType();
      await _apiService.registerDeviceToken(newToken, deviceType);
      await _prefs.setString('fcm_token', newToken);
    });
  }

  String _getDeviceType() {
    // Detect platform and return appropriate device type
    return 'web';
  }

  void _handleForegroundMessage(RemoteMessage message) {
    // Handle incoming call notification when app is in foreground
    if (message.data['type'] == 'incoming_call') {
      // Show incoming call UI
    }
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    // Handle notification click when app is in background
    if (message.data['type'] == 'incoming_call') {
      // Navigate to call screen
    }
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase if needed
  await Firebase.initializeApp();
  
  // Handle background message
  if (message.data['type'] == 'incoming_call') {
    // Show notification
  }
}
