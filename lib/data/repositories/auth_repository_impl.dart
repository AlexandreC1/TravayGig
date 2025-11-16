import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/logger.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

/// Implementation of AuthRepository
/// Handles error transformation from exceptions to failures
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, UserProfile?>> getCurrentUser() async {
    try {
      final result = await _remoteDataSource.getCurrentUser();
      return Right(result?.toEntity());
    } on AuthException catch (e) {
      AppLogger.error('Auth error in getCurrentUser', e);
      return Left(AuthFailure(e.message));
    } catch (e) {
      AppLogger.error('Unexpected error in getCurrentUser', e);
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final result = await _remoteDataSource.signUpWithEmail(
        email: email,
        password: password,
        fullName: fullName,
      );
      return Right(result.toEntity());
    } on AuthException catch (e) {
      AppLogger.error('Auth error in signUpWithEmail', e);
      return Left(AuthFailure(e.message));
    } catch (e) {
      AppLogger.error('Unexpected error in signUpWithEmail', e);
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _remoteDataSource.signInWithEmail(
        email: email,
        password: password,
      );
      return Right(result.toEntity());
    } on AuthException catch (e) {
      AppLogger.error('Auth error in signInWithEmail', e);
      return Left(AuthFailure(e.message));
    } catch (e) {
      AppLogger.error('Unexpected error in signInWithEmail', e);
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const Right(null);
    } on AuthException catch (e) {
      AppLogger.error('Auth error in signOut', e);
      return Left(AuthFailure(e.message));
    } catch (e) {
      AppLogger.error('Unexpected error in signOut', e);
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> updateProfile({
    required String userId,
    String? fullName,
    String? avatarUrl,
  }) async {
    try {
      final result = await _remoteDataSource.updateProfile(
        userId: userId,
        fullName: fullName,
        avatarUrl: avatarUrl,
      );
      return Right(result.toEntity());
    } on ServerException catch (e) {
      AppLogger.error('Server error in updateProfile', e);
      return Left(ServerFailure(e.message));
    } catch (e) {
      AppLogger.error('Unexpected error in updateProfile', e);
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPasswordForEmail(String email) async {
    try {
      await _remoteDataSource.resetPasswordForEmail(email);
      return const Right(null);
    } on AuthException catch (e) {
      AppLogger.error('Auth error in resetPasswordForEmail', e);
      return Left(AuthFailure(e.message));
    } catch (e) {
      AppLogger.error('Unexpected error in resetPasswordForEmail', e);
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updatePassword(String newPassword) async {
    try {
      await _remoteDataSource.updatePassword(newPassword);
      return const Right(null);
    } on AuthException catch (e) {
      AppLogger.error('Auth error in updatePassword', e);
      return Left(AuthFailure(e.message));
    } catch (e) {
      AppLogger.error('Unexpected error in updatePassword', e);
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Stream<UserProfile?> authStateChanges() {
    return _remoteDataSource
        .authStateChanges()
        .map((model) => model?.toEntity());
  }
}
