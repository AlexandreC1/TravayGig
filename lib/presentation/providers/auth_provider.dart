import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/logger.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/auth_repository.dart';
import 'repository_providers.dart';

/// State notifier for authentication
class AuthNotifier extends StateNotifier<AsyncValue<UserProfile?>> {
  final AuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(const AsyncValue.loading()) {
    _init();
  }

  /// Initialize auth state
  Future<void> _init() async {
    try {
      final result = await _authRepository.getCurrentUser();
      result.fold(
        (failure) {
          AppLogger.error('Failed to get current user', failure.message);
          state = AsyncValue.data(null);
        },
        (user) {
          state = AsyncValue.data(user);
        },
      );

      // Listen to auth state changes
      _authRepository.authStateChanges().listen(
        (user) {
          state = AsyncValue.data(user);
        },
        onError: (error) {
          AppLogger.error('Error in auth state stream', error);
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error initializing auth', e, stackTrace);
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Sign up with email and password
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    state = const AsyncValue.loading();

    final result = await _authRepository.signUpWithEmail(
      email: email,
      password: password,
      fullName: fullName,
    );

    result.fold(
      (failure) {
        AppLogger.error('Sign up failed', failure.message);
        state = AsyncValue.error(
          Exception(failure.message),
          StackTrace.current,
        );
      },
      (user) {
        state = AsyncValue.data(user);
      },
    );
  }

  /// Sign in with email and password
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    final result = await _authRepository.signInWithEmail(
      email: email,
      password: password,
    );

    result.fold(
      (failure) {
        AppLogger.error('Sign in failed', failure.message);
        state = AsyncValue.error(
          Exception(failure.message),
          StackTrace.current,
        );
      },
      (user) {
        state = AsyncValue.data(user);
      },
    );
  }

  /// Sign out
  Future<void> signOut() async {
    final result = await _authRepository.signOut();

    result.fold(
      (failure) {
        AppLogger.error('Sign out failed', failure.message);
      },
      (_) {
        state = const AsyncValue.data(null);
      },
    );
  }

  /// Update profile
  Future<void> updateProfile({
    String? fullName,
    String? avatarUrl,
  }) async {
    final currentUser = state.value;
    if (currentUser == null) return;

    final result = await _authRepository.updateProfile(
      userId: currentUser.id,
      fullName: fullName,
      avatarUrl: avatarUrl,
    );

    result.fold(
      (failure) {
        AppLogger.error('Update profile failed', failure.message);
      },
      (user) {
        state = AsyncValue.data(user);
      },
    );
  }

  /// Request password reset email
  /// Returns true if email was sent successfully, false otherwise
  Future<bool> resetPassword(String email) async {
    final result = await _authRepository.resetPasswordForEmail(email);

    return result.fold(
      (failure) {
        AppLogger.error('Password reset failed', failure.message);
        return false;
      },
      (_) {
        AppLogger.info('Password reset email sent to $email');
        return true;
      },
    );
  }

  /// Update password with new password
  /// Returns true if password was updated successfully
  Future<bool> updatePasswordWithNew(String newPassword) async {
    final result = await _authRepository.updatePassword(newPassword);

    return result.fold(
      (failure) {
        AppLogger.error('Password update failed', failure.message);
        return false;
      },
      (_) {
        AppLogger.info('Password updated successfully');
        return true;
      },
    );
  }
}

/// Provider for auth state
final authProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<UserProfile?>>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthNotifier(authRepository);
});

/// Provider for current user (convenience)
final currentUserProvider = Provider<UserProfile?>((ref) {
  return ref.watch(authProvider).value;
});
