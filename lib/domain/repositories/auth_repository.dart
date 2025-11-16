import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/user_profile.dart';

/// Abstract repository interface for authentication
/// Defines the contract for authentication operations
abstract class AuthRepository {
  /// Get current user session
  Future<Either<Failure, UserProfile?>> getCurrentUser();

  /// Sign up with email and password
  Future<Either<Failure, UserProfile>> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
  });

  /// Sign in with email and password
  Future<Either<Failure, UserProfile>> signInWithEmail({
    required String email,
    required String password,
  });

  /// Sign out current user
  Future<Either<Failure, void>> signOut();

  /// Update user profile
  Future<Either<Failure, UserProfile>> updateProfile({
    required String userId,
    String? fullName,
    String? avatarUrl,
  });

  /// Send password reset email
  Future<Either<Failure, void>> resetPasswordForEmail(String email);

  /// Update user password
  Future<Either<Failure, void>> updatePassword(String newPassword);

  /// Stream of auth state changes
  Stream<UserProfile?> authStateChanges();
}
