import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';
import '../../services/webrtc_service.dart';

class VideoCallScreen extends StatefulWidget {
  final String callId;
  final bool isIncoming;

  const VideoCallScreen({
    super.key,
    required this.callId,
    this.isIncoming = false,
  });

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();
  WebRTCService? _webRTCService;
  bool _isCallActive = false;

  @override
  void initState() {
    super.initState();
    _initializeCall();
  }

  Future<void> _initializeCall() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();

    final token = context.read<ApiService>().token;
    if (token == null) {
      _showError('No authentication token found');
      return;
    }

    _webRTCService = WebRTCService(
      onRemoteStream: (stream) {
        setState(() {
          _remoteRenderer.srcObject = stream;
          _isCallActive = true;
        });
      },
      onCallEnded: () {
        Navigator.of(context).pop();
      },
    );

    try {
      await _webRTCService?.initializeCall(widget.callId, token);
    } catch (e) {
      _showError('Failed to initialize call: $e');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
    Navigator.of(context).pop();
  }

  void _endCall() {
    _webRTCService?.endCall();
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _webRTCService?.dispose();
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Remote video (full screen)
            if (_isCallActive) ...[
              RTCVideoView(
                _remoteRenderer,
                objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
              ),
            ] else ...[
              const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ],
            
            // Local video (picture in picture)
            Positioned(
              right: 16,
              top: 16,
              width: 100,
              height: 150,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: RTCVideoView(
                    _localRenderer,
                    mirror: true,
                    objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                  ),
                ),
              ),
            ),
            
            // Call controls
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    onPressed: _endCall,
                    backgroundColor: Colors.red,
                    child: const Icon(Icons.call_end),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
