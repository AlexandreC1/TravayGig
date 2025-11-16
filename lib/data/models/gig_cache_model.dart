import 'package:hive/hive.dart';
import '../../domain/entities/gig.dart';

part 'gig_cache_model.g.dart';

/// Hive model for caching gigs locally
/// TypeId must be unique across all Hive adapters
@HiveType(typeId: 0)
class GigCacheModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final double price;

  @HiveField(5)
  final double latitude;

  @HiveField(6)
  final double longitude;

  @HiveField(7)
  final String? locationName;

  @HiveField(8)
  final DateTime createdAt;

  @HiveField(9)
  final DateTime? updatedAt;

  @HiveField(10)
  final String? userFullName;

  @HiveField(11)
  final String? userAvatarUrl;

  @HiveField(12)
  final DateTime cachedAt;

  GigCacheModel({
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
    required this.cachedAt,
  });

  /// Convert from domain entity
  factory GigCacheModel.fromEntity(Gig entity) {
    return GigCacheModel(
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
      cachedAt: DateTime.now(),
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

  /// Check if cache is expired
  bool isExpired(int expirationDays) {
    final now = DateTime.now();
    final difference = now.difference(cachedAt).inDays;
    return difference >= expirationDays;
  }
}
