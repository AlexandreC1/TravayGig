import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/gig.dart';
import '../../core/constants/database_constants.dart';

part 'gig_model.g.dart';

/// Data transfer object for Gig
/// Handles JSON serialization/deserialization for Supabase
@JsonSerializable()
class GigModel {
  @JsonKey(name: DatabaseConstants.gigId)
  final String id;

  @JsonKey(name: DatabaseConstants.gigUserId)
  final String userId;

  @JsonKey(name: DatabaseConstants.gigTitle)
  final String title;

  @JsonKey(name: DatabaseConstants.gigDescription)
  final String description;

  @JsonKey(name: DatabaseConstants.gigPrice)
  final double price;

  @JsonKey(name: DatabaseConstants.gigLatitude)
  final double latitude;

  @JsonKey(name: DatabaseConstants.gigLongitude)
  final double longitude;

  @JsonKey(name: DatabaseConstants.gigLocationName)
  final String? locationName;

  @JsonKey(name: DatabaseConstants.gigCreatedAt)
  final DateTime createdAt;

  @JsonKey(name: DatabaseConstants.gigUpdatedAt)
  final DateTime? updatedAt;

  // Fields populated from joined profile data
  @JsonKey(name: 'user_full_name')
  final String? userFullName;

  @JsonKey(name: 'user_avatar_url')
  final String? userAvatarUrl;

  const GigModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.price,
    required this.latitude,
    required this.longitude,
    this.locationName,
    required this.createdAt,
    this.updatedAt,
    this.userFullName,
    this.userAvatarUrl,
  });

  /// Convert from JSON
  factory GigModel.fromJson(Map<String, dynamic> json) =>
      _$GigModelFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$GigModelToJson(this);

  /// Convert from domain entity
  factory GigModel.fromEntity(Gig entity) {
    return GigModel(
      id: entity.id,
      userId: entity.userId,
      title: entity.title,
      description: entity.description,
      price: entity.price,
      latitude: entity.latitude,
      longitude: entity.longitude,
      locationName: entity.locationName,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      userFullName: entity.userFullName,
      userAvatarUrl: entity.userAvatarUrl,
    );
  }

  /// Convert to domain entity
  Gig toEntity() {
    return Gig(
      id: id,
      userId: userId,
      title: title,
      description: description,
      price: price,
      latitude: latitude,
      longitude: longitude,
      locationName: locationName,
      createdAt: createdAt,
      updatedAt: updatedAt,
      userFullName: userFullName,
      userAvatarUrl: userAvatarUrl,
    );
  }
}
