import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'services/api_service.dart';
import 'services/notification_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/video_call/video_call_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final dio = Dio();
  final apiService = ApiService(dio, prefs);

  runApp(MyApp(
    prefs: prefs,
    apiService: apiService,
  ));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  final ApiService apiService;

  const MyApp({
    super.key,
    required this.prefs,
    required this.apiService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>.value(value: apiService),
        Provider<NotificationService>(
          create: (context) => NotificationService(
            prefs,
            onCallReceived: (data) {
              // Handle incoming call notification
              if (data['call_id'] != null) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => VideoCallScreen(
                    callId: data['call_id'],
                    isIncoming: true,
                  ),
                ));
              }
            },
          ),
        ),
      ],
      child: MaterialApp(
        title: 'QR Doorbell',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => _handleAuth(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }

  Widget _handleAuth() {
    final token = prefs.getString('token');
    if (token != null) {
      return const HomeScreen();
    }
    return const LoginScreen();
  }
}
