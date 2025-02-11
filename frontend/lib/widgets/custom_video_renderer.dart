import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../utils/webrtc_helper.dart';

class CustomVideoRenderer extends StatefulWidget {
  final MediaStream? stream;
  
  const CustomVideoRenderer({Key? key, this.stream}) : super(key: key);

  @override
  State<CustomVideoRenderer> createState() => _CustomVideoRendererState();
}

class _CustomVideoRendererState extends State<CustomVideoRenderer> {
  final RTCVideoRenderer _renderer = RTCVideoRenderer();
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initRenderer();
  }

  Future<void> _initRenderer() async {
    await _renderer.initialize();
    if (widget.stream != null) {
      _renderer.srcObject = widget.stream;
      // Use our helper to safely get video tracks
      final videoTracks = WebRTCHelper.getTracksFromStream(widget.stream!, video: true);
      if (videoTracks.isNotEmpty) {
        setState(() {
          _initialized = true;
        });
      }
    }
  }

  @override
  void didUpdateWidget(CustomVideoRenderer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.stream != oldWidget.stream) {
      _renderer.srcObject = widget.stream;
    }
  }

  @override
  void dispose() {
    _renderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return RTCVideoView(_renderer);
  }
}
