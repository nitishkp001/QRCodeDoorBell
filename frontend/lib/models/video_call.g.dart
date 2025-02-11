// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_call.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VideoCallImpl _$$VideoCallImplFromJson(Map<String, dynamic> json) =>
    _$VideoCallImpl(
      id: json['id'] as String,
      visitorId: json['visitorId'] as String,
      ownerId: json['ownerId'] as String,
      qrCodeId: json['qrCodeId'] as String,
      status: $enumDecode(_$CallStatusEnumMap, json['status']),
      sessionId: json['sessionId'] as String?,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
    );

Map<String, dynamic> _$$VideoCallImplToJson(_$VideoCallImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'visitorId': instance.visitorId,
      'ownerId': instance.ownerId,
      'qrCodeId': instance.qrCodeId,
      'status': _$CallStatusEnumMap[instance.status]!,
      'sessionId': instance.sessionId,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
    };

const _$CallStatusEnumMap = {
  CallStatus.initiated: 'initiated',
  CallStatus.connected: 'connected',
  CallStatus.completed: 'completed',
  CallStatus.missed: 'missed',
  CallStatus.rejected: 'rejected',
};
