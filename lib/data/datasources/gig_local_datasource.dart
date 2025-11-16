import 'package:hive/hive.dart';
import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/utils/logger.dart';
import '../models/gig_cache_model.dart';
import '../../domain/entities/gig.dart';

/// Local data source for caching gigs using Hive
class GigLocalDataSource {
  final Box<GigCacheModel> _gigBox;

  GigLocalDataSource(this._gigBox);

  /// Get cached gigs
  Future<List<GigCacheModel>> getCachedGigs() async {
    try {
      // Remove expired cache entries
      await _removeExpiredCache();

      return _gigBox.values.toList();
    } catch (e, stackTrace) {
      AppLogger.error('Error getting cached gigs', e, stackTrace);
      throw CacheException('Failed to get cached gigs: $e');
    }
  }

  /// Cache a list of gigs
  Future<void> cacheGigs(List<Gig> gigs) async {
    try {
      // Clear old cache if it exceeds max size
      if (_gigBox.length > AppConstants.maxGigsCache) {
        await _gigBox.clear();
      }

      // Cache each gig
      for (final gig in gigs) {
        final cacheModel = GigCacheModel.fromEntity(gig);
        await _gigBox.put(gig.id, cacheModel);
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error caching gigs', e, stackTrace);
      throw CacheException('Failed to cache gigs: $e');
    }
  }

  /// Cache a single gig
  Future<void> cacheGig(Gig gig) async {
    try {
      final cacheModel = GigCacheModel.fromEntity(gig);
      await _gigBox.put(gig.id, cacheModel);
    } catch (e, stackTrace) {
      AppLogger.error('Error caching gig', e, stackTrace);
      throw CacheException('Failed to cache gig: $e');
    }
  }

  /// Remove a cached gig
  Future<void> removeCachedGig(String gigId) async {
    try {
      await _gigBox.delete(gigId);
    } catch (e, stackTrace) {
      AppLogger.error('Error removing cached gig', e, stackTrace);
      throw CacheException('Failed to remove cached gig: $e');
    }
  }

  /// Clear all cached gigs
  Future<void> clearCache() async {
    try {
      await _gigBox.clear();
    } catch (e, stackTrace) {
      AppLogger.error('Error clearing cache', e, stackTrace);
      throw CacheException('Failed to clear cache: $e');
    }
  }

  /// Remove expired cache entries
  Future<void> _removeExpiredCache() async {
    final expiredKeys = <String>[];

    for (final entry in _gigBox.toMap().entries) {
      if (entry.value.isExpired(AppConstants.cacheExpirationDays)) {
        expiredKeys.add(entry.key);
      }
    }

    for (final key in expiredKeys) {
      await _gigBox.delete(key);
    }
  }
}
