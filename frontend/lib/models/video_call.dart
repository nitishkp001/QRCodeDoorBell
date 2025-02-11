import 'package:freezed_annotation/freezed_annotation.dart';

part 'video_call.freezed.dart';
part 'video_call.g.dart';

enum CallStatus {
  initiated,
  connected,
  completed,
  missed,
  rejected,
}

@freezed
class VideoCall with _$VideoCall {
  const factory VideoCall({
    required String id,
    required String visitorId,
    required String ownerId,
    required String qrCodeId,
    required CallStatus status,
    String? sessionId,
    required DateTime startTime,
    DateTime? endTime,
  }) = _VideoCall;

  factory VideoCall.fromJson(Map<String, dynamic> json) => _$VideoCallFromJson(json);
}
