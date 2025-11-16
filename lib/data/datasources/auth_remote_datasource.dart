import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/database_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/utils/logger.dart';
import '../models/user_profile_model.dart';

/// Remote data source for authentication using Supabase
class AuthRemoteDataSource {
  final SupabaseClient _supabase;

  AuthRemoteDataSource(this._supabase);

  /// Get current authenticated user profile
  Future<UserProfileModel?> getCurrentUser() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;

      final response = await _supabase
          .from(DatabaseConstants.profilesTable)
          .select()
          .eq(DatabaseConstants.profileId, user.id)
          .single();

      return UserProfileModel.fromJson(response);
    } catch (e, stackTrace) {
      AppLogger.error('Error getting current user', e, stackTrace);
      throw AuthException('Failed to get current user: $e');
    }
  }

  /// Sign up with email and password
  Future<UserProfileModel> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      // Create auth user
      final authResponse = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (authResponse.user == null) {
        throw AuthException('Sign up failed: No user returned');
      }

      // Create profile (triggered by database trigger or manually)
      final profileData = {
        DatabaseConstants.profileId: authResponse.user!.id,
        DatabaseConstants.profileEmail: email,
        DatabaseConstants.profileFullName: fullName,
        DatabaseConstants.profileCreatedAt: DateTime.now().toIso8601String(),
      };

      final response = await _supabase
          .from(DatabaseConstants.profilesTable)
          .upsert(profileData)
          .select()
          .single();

      return UserProfileModel.fromJson(response);
    } catch (e, stackTrace) {
      AppLogger.error('Error signing up', e, stackTrace);
      throw AuthException('Sign up failed: $e');
    }
  }

  /// Sign in with email and password
  Future<UserProfileModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final authResponse = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (authResponse.user == null) {
        throw AuthException('Sign in failed: No user returned');
      }

      final response = await _supabase
          .from(DatabaseConstants.profilesTable)
          .select()
          .eq(DatabaseConstants.profileId, authResponse.user!.id)
          .single();

      return UserProfileModel.fromJson(response);
    } catch (e, stackTrace) {
      AppLogger.error('Error signing in', e, stackTrace);
      throw AuthException('Sign in failed: $e');
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e, stackTrace) {
      AppLogger.error('Error signing out', e, stackTrace);
      throw AuthException('Sign out failed: $e');
    }
  }

  /// Update user profile
  Future<UserProfileModel> updateProfile({
    required String userId,
    String? fullName,
    String? avatarUrl,
  }) async {
    try {
      final updateData = <String, dynamic>{
        DatabaseConstants.profileUpdatedAt: DateTime.now().toIso8601String(),
      };

      if (fullName != null) {
        updateData[DatabaseConstants.profileFullName] = fullName;
      }
      if (avatarUrl != null) {
        updateData[DatabaseConstants.profileAvatarUrl] = avatarUrl;
      }

      final response = await _supabase
          .from(DatabaseConstants.profilesTable)
          .update(updateData)
          .eq(DatabaseConstants.profileId, userId)
          .select()
          .single();

      return UserProfileModel.fromJson(response);
    } catch (e, stackTrace) {
      AppLogger.error('Error updating profile', e, stackTrace);
      throw ServerException('Failed to update profile: $e');
    }
  }

  /// Stream of auth state changes
  Stream<UserProfileModel?> authStateChanges() {
    return _supabase.auth.onAuthStateChange.asyncMap((event) async {
      final user = event.session?.user;
      if (user == null) return null;

      try {
        final response = await _supabase
            .from(DatabaseConstants.profilesTable)
            .select()
            .eq(DatabaseConstants.profileId, user.id)
            .single();

        return UserProfileModel.fromJson(response);
      } catch (e) {
        AppLogger.error('Error in auth state change stream', e);
        return null;
      }
    });
  }

  /// Send password reset email
  /// Supabase will send an email with a reset link to the user
  Future<void> resetPasswordForEmail(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } catch (e, stackTrace) {
      AppLogger.error('Error sending password reset email', e, stackTrace);
      throw AuthException('Failed to send password reset email: $e');
    }
  }

  /// Update user password (after receiving reset link)
  /// This is called when user clicks the reset link and provides a new password
  Future<void> updatePassword(String newPassword) async {
    try {
      await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error updating password', e, stackTrace);
      throw AuthException('Failed to update password: $e');
    }
  }
}
