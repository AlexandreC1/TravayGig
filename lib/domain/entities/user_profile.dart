import 'package:equatable/equatable.dart';

/// Domain entity representing a user profile
/// Clean domain model without any infrastructure concerns
class UserProfile extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const UserProfile({
    required this.id,
    required this.email,
    required this.fullName,
    this.avatarUrl,
    required this.createdAt,
    this.updatedAt,
  });

  /// Create a copy with updated fields
  UserProfile copyWith({
    String? id,
    String? email,
    String? fullName,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        fullName,
        avatarUrl,
        createdAt,
        updatedAt,
      ];
}
