import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'dart:js_util' as js_util;

class WebRTCHelper {
  static List<MediaStreamTrack> getTracksFromStream(MediaStream stream, {bool video = true}) {
    try {
      final tracks = video 
          ? js_util.callMethod(stream.jsStream, 'getVideoTracks', [])
          : js_util.callMethod(stream.jsStream, 'getAudioTracks', []);
      return List<MediaStreamTrack>.from(tracks);
    } catch (e) {
      print('Error getting tracks: $e');
      return [];
    }
  }
}
