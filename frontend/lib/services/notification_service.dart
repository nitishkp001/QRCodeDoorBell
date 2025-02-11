import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart' as sp;
import 'package:web_socket_channel/web_socket_channel.dart';

class NotificationService {
  WebSocketChannel? _notificationChannel;
  final sp.SharedPreferences _prefs;
  final Function(Map<String, dynamic>) onCallReceived;

  NotificationService(this._prefs, {required this.onCallReceived});

  void initialize() {
    if (_notificationChannel != null) return;

    final token = _prefs.getString('token');
    if (token == null) return;

    final wsUrl = 'ws://localhost:8000/api/v1/notifications/ws?token=$token';
    _notificationChannel = WebSocketChannel.connect(
      Uri.parse(wsUrl),
    );

    _notificationChannel?.stream.listen(
      (message) {
        final data = jsonDecode(message);
        if (data['type'] == 'incoming_call') {
          onCallReceived(data);
        }
      },
      onError: (error) {
        print('WebSocket error: $error');
        _reconnect();
      },
      onDone: () {
        print('WebSocket connection closed');
        _reconnect();
      },
    );
  }

  void _reconnect() {
    Future.delayed(const Duration(seconds: 5), () {
      dispose();
      initialize();
    });
  }

  void dispose() {
    _notificationChannel?.sink.close();
    _notificationChannel = null;
  }
}
