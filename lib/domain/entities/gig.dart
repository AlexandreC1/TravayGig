import 'package:equatable/equatable.dart';

/// Domain entity representing a gig/job posting
/// Immutable entity following clean architecture principles
class Gig extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String description;
  final double price;
  final double latitude;
  final double longitude;
  final String? locationName;
  final DateTime createdAt;
  final DateTime? updatedAt;

  // Optional: populated when fetching with user data
  final String? userFullName;
  final String? userAvatarUrl;

  const Gig({
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

  /// Create a copy with updated fields
  Gig copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    double? price,
    double? latitude,
    double? longitude,
    String? locationName,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userFullName,
    String? userAvatarUrl,
  }) {
    return Gig(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationName: locationName ?? this.locationName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userFullName: userFullName ?? this.userFullName,
      userAvatarUrl: userAvatarUrl ?? this.userAvatarUrl,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        description,
        price,
        latitude,
        longitude,
        locationName,
        createdAt,
        updatedAt,
        userFullName,
        userAvatarUrl,
      ];
}
