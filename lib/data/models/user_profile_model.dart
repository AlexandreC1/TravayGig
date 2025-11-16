import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user_profile.dart';
import '../../core/constants/database_constants.dart';

part 'user_profile_model.g.dart';

/// Data transfer object for UserProfile
/// Handles JSON serialization/deserialization for Supabase
@JsonSerializable()
class UserProfileModel {
  @JsonKey(name: DatabaseConstants.profileId)
  final String id;

  @JsonKey(name: DatabaseConstants.profileEmail)
  final String email;

  @JsonKey(name: DatabaseConstants.profileFullName)
  final String fullName;

  @JsonKey(name: DatabaseConstants.profileAvatarUrl)
  final String? avatarUrl;

  @JsonKey(name: DatabaseConstants.profileCreatedAt)
  final DateTime createdAt;

  @JsonKey(name: DatabaseConstants.profileUpdatedAt)
  final DateTime? updatedAt;

  const UserProfileModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.avatarUrl,
    required this.createdAt,
    this.updatedAt,
  });

  /// Convert from JSON
  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);

  /// Convert from domain entity
  factory UserProfileModel.fromEntity(UserProfile entity) {
    return UserProfileModel(
      id: entity.id,
      email: entity.email,
      fullName: entity.fullName,
      avatarUrl: entity.avatarUrl,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Convert to domain entity
  UserProfile toEntity() {
    return UserProfile(
      id: id,
      email: email,
      fullName: fullName,
      avatarUrl: avatarUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
