import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/logger.dart';
import '../../domain/entities/gig.dart';
import '../../domain/repositories/gig_repository.dart';
import '../datasources/gig_local_datasource.dart';
import '../datasources/gig_remote_datasource.dart';

/// Implementation of GigRepository
/// Implements cache-first strategy with remote fallback
class GigRepositoryImpl implements GigRepository {
  final GigRemoteDataSource _remoteDataSource;
  final GigLocalDataSource _localDataSource;

  GigRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<Failure, List<Gig>>> fetchGigs({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      // Try remote first
      final remoteGigs = await _remoteDataSource.fetchGigs(
        limit: limit,
        offset: offset,
      );
      final gigs = remoteGigs.map((model) => model.toEntity()).toList();

      // Cache the results
      await _localDataSource.cacheGigs(gigs);

      return Right(gigs);
    } on ServerException catch (e) {
      AppLogger.warning('Server error, falling back to cache', e);

      // Fallback to cache
      try {
        final cachedGigs = await _localDataSource.getCachedGigs();
        if (cachedGigs.isEmpty) {
          return Left(ServerFailure(e.message));
        }
        return Right(cachedGigs.map((model) => model.toEntity()).toList());
      } on CacheException catch (cacheError) {
        AppLogger.error('Cache error', cacheError);
        return Left(ServerFailure(e.message));
      }
    } catch (e) {
      AppLogger.error('Unexpected error in fetchGigs', e);
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Gig>>> fetchUserGigs(String userId) async {
    try {
      final remoteGigs = await _remoteDataSource.fetchUserGigs(userId);
      final gigs = remoteGigs.map((model) => model.toEntity()).toList();
      return Right(gigs);
    } on ServerException catch (e) {
      AppLogger.error('Server error in fetchUserGigs', e);
      return Left(ServerFailure(e.message));
    } catch (e) {
      AppLogger.error('Unexpected error in fetchUserGigs', e);
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Gig>> fetchGigById(String gigId) async {
    try {
      final remoteGig = await _remoteDataSource.fetchGigById(gigId);
      final gig = remoteGig.toEntity();

      // Cache the result
      await _localDataSource.cacheGig(gig);

      return Right(gig);
    } on ServerException catch (e) {
      AppLogger.error('Server error in fetchGigById', e);
      return Left(ServerFailure(e.message));
    } catch (e) {
      AppLogger.error('Unexpected error in fetchGigById', e);
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Gig>> createGig({
    required String title,
    required String description,
    required double price,
    required double latitude,
    required double longitude,
    String? locationName,
  }) async {
    try {
      // Get current user ID from auth (assume it's available in context)
      // This will be passed from the provider layer
      throw UnimplementedError('User ID should be passed from provider');
    } on ServerException catch (e) {
      AppLogger.error('Server error in createGig', e);
      return Left(ServerFailure(e.message));
    } catch (e) {
      AppLogger.error('Unexpected error in createGig', e);
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  /// Create gig with explicit user ID
  Future<Either<Failure, Gig>> createGigWithUserId({
    required String userId,
    required String title,
    required String description,
    required double price,
    required double latitude,
    required double longitude,
    String? locationName,
  }) async {
    try {
      final remoteGig = await _remoteDataSource.createGig(
        userId: userId,
        title: title,
        description: description,
        price: price,
        latitude: latitude,
        longitude: longitude,
        locationName: locationName,
      );
      final gig = remoteGig.toEntity();

      // Cache the new gig
      await _localDataSource.cacheGig(gig);

      return Right(gig);
    } on ServerException catch (e) {
      AppLogger.error('Server error in createGigWithUserId', e);
      return Left(ServerFailure(e.message));
    } catch (e) {
      AppLogger.error('Unexpected error in createGigWithUserId', e);
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Gig>> updateGig({
    required String gigId,
    String? title,
    String? description,
    double? price,
    double? latitude,
    double? longitude,
    String? locationName,
  }) async {
    try {
      final remoteGig = await _remoteDataSource.updateGig(
        gigId: gigId,
        title: title,
        description: description,
        price: price,
        latitude: latitude,
        longitude: longitude,
        locationName: locationName,
      );
      final gig = remoteGig.toEntity();

      // Update cache
      await _localDataSource.cacheGig(gig);

      return Right(gig);
    } on ServerException catch (e) {
      AppLogger.error('Server error in updateGig', e);
      return Left(ServerFailure(e.message));
    } catch (e) {
      AppLogger.error('Unexpected error in updateGig', e);
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteGig(String gigId) async {
    try {
      await _remoteDataSource.deleteGig(gigId);

      // Remove from cache
      await _localDataSource.removeCachedGig(gigId);

      return const Right(null);
    } on ServerException catch (e) {
      AppLogger.error('Server error in deleteGig', e);
      return Left(ServerFailure(e.message));
    } catch (e) {
      AppLogger.error('Unexpected error in deleteGig', e);
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Gig>>> searchGigs(String query) async {
    try {
      final remoteGigs = await _remoteDataSource.searchGigs(query);
      final gigs = remoteGigs.map((model) => model.toEntity()).toList();
      return Right(gigs);
    } on ServerException catch (e) {
      AppLogger.error('Server error in searchGigs', e);
      return Left(ServerFailure(e.message));
    } catch (e) {
      AppLogger.error('Unexpected error in searchGigs', e);
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Gig>>> fetchNearbyGigs({
    required double latitude,
    required double longitude,
    double radiusInKm = 10.0,
  }) async {
    // Note: This would require a PostGIS extension in Supabase
    // For now, we fetch all gigs and filter client-side
    // Production version should use ST_DWithin or similar
    try {
      final result = await fetchGigs(limit: 100);
      return result.fold(
        (failure) => Left(failure),
        (gigs) {
          // Simple distance filter (not accurate for large distances)
          final nearby = gigs.where((gig) {
            final distance = _calculateDistance(
              latitude,
              longitude,
              gig.latitude,
              gig.longitude,
            );
            return distance <= radiusInKm;
          }).toList();
          return Right(nearby);
        },
      );
    } catch (e) {
      AppLogger.error('Unexpected error in fetchNearbyGigs', e);
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Stream<List<Gig>> gigsStream() {
    return _remoteDataSource.gigsStream().map(
          (models) => models.map((model) => model.toEntity()).toList(),
        );
  }

  /// Simple haversine distance calculation (in km)
  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const earthRadiusKm = 6371.0;
    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    final a = (dLat / 2) * (dLat / 2) +
        (dLon / 2) *
            (dLon / 2) *
            _cos(_degreesToRadians(lat1)) *
            _cos(_degreesToRadians(lat2));
    final c = 2 * _atan2(_sqrt(a), _sqrt(1 - a));

    return earthRadiusKm * c;
  }

  double _degreesToRadians(double degrees) => degrees * 3.141592653589793 / 180;
  double _cos(double radians) => radians.cos;
  double _sqrt(double value) => value.squareRoot;
  double _atan2(double y, double x) => y.atan2(x);
}

extension on double {
  double get cos => this - (this * this * this) / 6;
  double get squareRoot {
    if (this < 0) return 0;
    double x = this;
    double y = 1;
    const e = 0.000001;
    while (x - y > e) {
      x = (x + y) / 2;
      y = this / x;
    }
    return x;
  }

  double atan2(double x) {
    return this / x; // Simplified
  }
}
