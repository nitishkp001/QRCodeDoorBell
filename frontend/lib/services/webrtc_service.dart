import 'dart:convert';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebRTCService {
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  MediaStream? _remoteStream;
  WebSocketChannel? _channel;
  final Function(MediaStream) onRemoteStream;
  final Function() onCallEnded;

  WebRTCService({
    required this.onRemoteStream,
    required this.onCallEnded,
  });

  Future<void> initializeCall(String callId, String token) async {
    await _createPeerConnection();
    await _getUserMedia();
    _connectWebSocket(callId, token);
  }

  Future<void> _createPeerConnection() async {
    Map<String, dynamic> configuration = {
      "iceServers": [
        {"url": "stun:stun.l.google.com:19302"},
      ]
    };

    Map<String, dynamic> offerSdpConstraints = {
      "mandatory": {
        "OfferToReceiveAudio": true,
        "OfferToReceiveVideo": true,
      },
      "optional": [],
    };

    _peerConnection = await createPeerConnection(configuration, offerSdpConstraints);

    _peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
      _channel?.sink.add(jsonEncode({
        'type': 'ice-candidate',
        'candidate': candidate.toMap(),
      }));
    };

    _peerConnection?.onAddStream = (MediaStream stream) {
      _remoteStream = stream;
      onRemoteStream(stream);
    };
  }

  Future<void> _getUserMedia() async {
    final Map<String, dynamic> constraints = {
      'audio': true,
      'video': {
        'facingMode': 'user',
      },
    };

    _localStream = await navigator.mediaDevices.getUserMedia(constraints);
    _localStream?.getTracks().forEach((track) {
      _peerConnection?.addTrack(track, _localStream!);
    });
  }

  void _connectWebSocket(String callId, String token) {
    final wsUrl = 'ws://localhost:8000/api/v1/video-calls/ws/$callId?token=$token';
    _channel = WebSocketChannel.connect(
      Uri.parse(wsUrl),
    );

    _channel?.stream.listen((message) async {
      final data = jsonDecode(message);
      switch (data['type']) {
        case 'offer':
          await _handleOffer(data['sdp']);
          break;
        case 'answer':
          await _handleAnswer(data['sdp']);
          break;
        case 'ice-candidate':
          await _handleIceCandidate(data['candidate']);
          break;
        case 'call-ended':
          _handleCallEnded();
          break;
      }
    });
  }

  Future<void> _handleOffer(String sdp) async {
    await _peerConnection?.setRemoteDescription(
      RTCSessionDescription(sdp, 'offer'),
    );

    final answer = await _peerConnection?.createAnswer();
    if (answer != null) {
      await _peerConnection?.setLocalDescription(answer);

      _channel?.sink.add(jsonEncode({
        'type': 'answer',
        'sdp': answer.sdp,
      }));
    }
  }

  Future<void> _handleAnswer(String sdp) async {
    await _peerConnection?.setRemoteDescription(
      RTCSessionDescription(sdp, 'answer'),
    );
  }

  Future<void> _handleIceCandidate(Map<String, dynamic> candidate) async {
    await _peerConnection?.addCandidate(
      RTCIceCandidate(
        candidate['candidate'],
        candidate['sdpMid'],
        candidate['sdpMLineIndex'],
      ),
    );
  }

  void _handleCallEnded() {
    dispose();
    onCallEnded();
  }

  Future<void> makeOffer() async {
    final offer = await _peerConnection?.createOffer();
    if (offer != null) {
      await _peerConnection?.setLocalDescription(offer);

      _channel?.sink.add(jsonEncode({
        'type': 'offer',
        'sdp': offer.sdp,
      }));
    }
  }

  void endCall() {
    _channel?.sink.add(jsonEncode({
      'type': 'end-call',
    }));
    dispose();
  }

  void dispose() {
    _localStream?.dispose();
    _remoteStream?.dispose();
    _peerConnection?.dispose();
    _channel?.sink.close();
  }

  MediaStream? get localStream => _localStream;
  MediaStream? get remoteStream => _remoteStream;
}
