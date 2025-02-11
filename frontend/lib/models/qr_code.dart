import 'package:freezed_annotation/freezed_annotation.dart';

part 'qr_code.freezed.dart';
part 'qr_code.g.dart';

@freezed
class QRCode with _$QRCode {
  const factory QRCode({
    String? id,
    String? ownerId,
    required String name,
    String? description,
    @Default(true) bool isActive,
    DateTime? expiryDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _QRCode;

  factory QRCode.fromJson(Map<String, dynamic> json) => _$QRCodeFromJson(json);
}
