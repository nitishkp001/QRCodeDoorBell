// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'qr_code.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

QRCode _$QRCodeFromJson(Map<String, dynamic> json) {
  return _QRCode.fromJson(json);
}

/// @nodoc
mixin _$QRCode {
  String? get id => throw _privateConstructorUsedError;
  String? get ownerId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime? get expiryDate => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this QRCode to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QRCode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QRCodeCopyWith<QRCode> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QRCodeCopyWith<$Res> {
  factory $QRCodeCopyWith(QRCode value, $Res Function(QRCode) then) =
      _$QRCodeCopyWithImpl<$Res, QRCode>;
  @useResult
  $Res call(
      {String? id,
      String? ownerId,
      String name,
      String? description,
      bool isActive,
      DateTime? expiryDate,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$QRCodeCopyWithImpl<$Res, $Val extends QRCode>
    implements $QRCodeCopyWith<$Res> {
  _$QRCodeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QRCode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? ownerId = freezed,
    Object? name = null,
    Object? description = freezed,
    Object? isActive = null,
    Object? expiryDate = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerId: freezed == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      expiryDate: freezed == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QRCodeImplCopyWith<$Res> implements $QRCodeCopyWith<$Res> {
  factory _$$QRCodeImplCopyWith(
          _$QRCodeImpl value, $Res Function(_$QRCodeImpl) then) =
      __$$QRCodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String? ownerId,
      String name,
      String? description,
      bool isActive,
      DateTime? expiryDate,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$QRCodeImplCopyWithImpl<$Res>
    extends _$QRCodeCopyWithImpl<$Res, _$QRCodeImpl>
    implements _$$QRCodeImplCopyWith<$Res> {
  __$$QRCodeImplCopyWithImpl(
      _$QRCodeImpl _value, $Res Function(_$QRCodeImpl) _then)
      : super(_value, _then);

  /// Create a copy of QRCode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? ownerId = freezed,
    Object? name = null,
    Object? description = freezed,
    Object? isActive = null,
    Object? expiryDate = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$QRCodeImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerId: freezed == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      expiryDate: freezed == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QRCodeImpl implements _QRCode {
  const _$QRCodeImpl(
      {this.id,
      this.ownerId,
      required this.name,
      this.description,
      this.isActive = true,
      this.expiryDate,
      this.createdAt,
      this.updatedAt});

  factory _$QRCodeImpl.fromJson(Map<String, dynamic> json) =>
      _$$QRCodeImplFromJson(json);

  @override
  final String? id;
  @override
  final String? ownerId;
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime? expiryDate;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'QRCode(id: $id, ownerId: $ownerId, name: $name, description: $description, isActive: $isActive, expiryDate: $expiryDate, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QRCodeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.expiryDate, expiryDate) ||
                other.expiryDate == expiryDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, ownerId, name, description,
      isActive, expiryDate, createdAt, updatedAt);

  /// Create a copy of QRCode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QRCodeImplCopyWith<_$QRCodeImpl> get copyWith =>
      __$$QRCodeImplCopyWithImpl<_$QRCodeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QRCodeImplToJson(
      this,
    );
  }
}

abstract class _QRCode implements QRCode {
  const factory _QRCode(
      {final String? id,
      final String? ownerId,
      required final String name,
      final String? description,
      final bool isActive,
      final DateTime? expiryDate,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$QRCodeImpl;

  factory _QRCode.fromJson(Map<String, dynamic> json) = _$QRCodeImpl.fromJson;

  @override
  String? get id;
  @override
  String? get ownerId;
  @override
  String get name;
  @override
  String? get description;
  @override
  bool get isActive;
  @override
  DateTime? get expiryDate;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of QRCode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QRCodeImplCopyWith<_$QRCodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
