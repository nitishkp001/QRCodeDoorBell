// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_call.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VideoCall _$VideoCallFromJson(Map<String, dynamic> json) {
  return _VideoCall.fromJson(json);
}

/// @nodoc
mixin _$VideoCall {
  String get id => throw _privateConstructorUsedError;
  String get visitorId => throw _privateConstructorUsedError;
  String get ownerId => throw _privateConstructorUsedError;
  String get qrCodeId => throw _privateConstructorUsedError;
  CallStatus get status => throw _privateConstructorUsedError;
  String? get sessionId => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime? get endTime => throw _privateConstructorUsedError;

  /// Serializes this VideoCall to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VideoCall
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VideoCallCopyWith<VideoCall> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VideoCallCopyWith<$Res> {
  factory $VideoCallCopyWith(VideoCall value, $Res Function(VideoCall) then) =
      _$VideoCallCopyWithImpl<$Res, VideoCall>;
  @useResult
  $Res call(
      {String id,
      String visitorId,
      String ownerId,
      String qrCodeId,
      CallStatus status,
      String? sessionId,
      DateTime startTime,
      DateTime? endTime});
}

/// @nodoc
class _$VideoCallCopyWithImpl<$Res, $Val extends VideoCall>
    implements $VideoCallCopyWith<$Res> {
  _$VideoCallCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VideoCall
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? visitorId = null,
    Object? ownerId = null,
    Object? qrCodeId = null,
    Object? status = null,
    Object? sessionId = freezed,
    Object? startTime = null,
    Object? endTime = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      visitorId: null == visitorId
          ? _value.visitorId
          : visitorId // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      qrCodeId: null == qrCodeId
          ? _value.qrCodeId
          : qrCodeId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as CallStatus,
      sessionId: freezed == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VideoCallImplCopyWith<$Res>
    implements $VideoCallCopyWith<$Res> {
  factory _$$VideoCallImplCopyWith(
          _$VideoCallImpl value, $Res Function(_$VideoCallImpl) then) =
      __$$VideoCallImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String visitorId,
      String ownerId,
      String qrCodeId,
      CallStatus status,
      String? sessionId,
      DateTime startTime,
      DateTime? endTime});
}

/// @nodoc
class __$$VideoCallImplCopyWithImpl<$Res>
    extends _$VideoCallCopyWithImpl<$Res, _$VideoCallImpl>
    implements _$$VideoCallImplCopyWith<$Res> {
  __$$VideoCallImplCopyWithImpl(
      _$VideoCallImpl _value, $Res Function(_$VideoCallImpl) _then)
      : super(_value, _then);

  /// Create a copy of VideoCall
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? visitorId = null,
    Object? ownerId = null,
    Object? qrCodeId = null,
    Object? status = null,
    Object? sessionId = freezed,
    Object? startTime = null,
    Object? endTime = freezed,
  }) {
    return _then(_$VideoCallImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      visitorId: null == visitorId
          ? _value.visitorId
          : visitorId // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      qrCodeId: null == qrCodeId
          ? _value.qrCodeId
          : qrCodeId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as CallStatus,
      sessionId: freezed == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VideoCallImpl implements _VideoCall {
  const _$VideoCallImpl(
      {required this.id,
      required this.visitorId,
      required this.ownerId,
      required this.qrCodeId,
      required this.status,
      this.sessionId,
      required this.startTime,
      this.endTime});

  factory _$VideoCallImpl.fromJson(Map<String, dynamic> json) =>
      _$$VideoCallImplFromJson(json);

  @override
  final String id;
  @override
  final String visitorId;
  @override
  final String ownerId;
  @override
  final String qrCodeId;
  @override
  final CallStatus status;
  @override
  final String? sessionId;
  @override
  final DateTime startTime;
  @override
  final DateTime? endTime;

  @override
  String toString() {
    return 'VideoCall(id: $id, visitorId: $visitorId, ownerId: $ownerId, qrCodeId: $qrCodeId, status: $status, sessionId: $sessionId, startTime: $startTime, endTime: $endTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideoCallImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.visitorId, visitorId) ||
                other.visitorId == visitorId) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.qrCodeId, qrCodeId) ||
                other.qrCodeId == qrCodeId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, visitorId, ownerId, qrCodeId,
      status, sessionId, startTime, endTime);

  /// Create a copy of VideoCall
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VideoCallImplCopyWith<_$VideoCallImpl> get copyWith =>
      __$$VideoCallImplCopyWithImpl<_$VideoCallImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VideoCallImplToJson(
      this,
    );
  }
}

abstract class _VideoCall implements VideoCall {
  const factory _VideoCall(
      {required final String id,
      required final String visitorId,
      required final String ownerId,
      required final String qrCodeId,
      required final CallStatus status,
      final String? sessionId,
      required final DateTime startTime,
      final DateTime? endTime}) = _$VideoCallImpl;

  factory _VideoCall.fromJson(Map<String, dynamic> json) =
      _$VideoCallImpl.fromJson;

  @override
  String get id;
  @override
  String get visitorId;
  @override
  String get ownerId;
  @override
  String get qrCodeId;
  @override
  CallStatus get status;
  @override
  String? get sessionId;
  @override
  DateTime get startTime;
  @override
  DateTime? get endTime;

  /// Create a copy of VideoCall
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VideoCallImplCopyWith<_$VideoCallImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
