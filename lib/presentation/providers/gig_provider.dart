import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/logger.dart';
import '../../domain/entities/gig.dart';
import '../../domain/repositories/gig_repository.dart';
import '../../data/repositories/gig_repository_impl.dart';
import 'repository_providers.dart';
import 'auth_provider.dart';

/// State notifier for gigs list
class GigsNotifier extends StateNotifier<AsyncValue<List<Gig>>> {
  final GigRepository _gigRepository;

  GigsNotifier(this._gigRepository) : super(const AsyncValue.loading()) {
    loadGigs();
  }

  /// Load all gigs
  Future<void> loadGigs() async {
    state = const AsyncValue.loading();

    final result = await _gigRepository.fetchGigs();

    result.fold(
      (failure) {
        AppLogger.error('Failed to load gigs', failure.message);
        state = AsyncValue.error(
          Exception(failure.message),
          StackTrace.current,
        );
      },
      (gigs) {
        state = AsyncValue.data(gigs);
      },
    );
  }

  /// Search gigs
  Future<void> searchGigs(String query) async {
    if (query.isEmpty) {
      await loadGigs();
      return;
    }

    state = const AsyncValue.loading();

    final result = await _gigRepository.searchGigs(query);

    result.fold(
      (failure) {
        AppLogger.error('Failed to search gigs', failure.message);
        state = AsyncValue.error(
          Exception(failure.message),
          StackTrace.current,
        );
      },
      (gigs) {
        state = AsyncValue.data(gigs);
      },
    );
  }

  /// Fetch nearby gigs
  Future<void> loadNearbyGigs(double latitude, double longitude) async {
    state = const AsyncValue.loading();

    final result = await _gigRepository.fetchNearbyGigs(
      latitude: latitude,
      longitude: longitude,
    );

    result.fold(
      (failure) {
        AppLogger.error('Failed to load nearby gigs', failure.message);
        state = AsyncValue.error(
          Exception(failure.message),
          StackTrace.current,
        );
      },
      (gigs) {
        state = AsyncValue.data(gigs);
      },
    );
  }
}

/// Provider for gigs list
final gigsProvider =
    StateNotifierProvider<GigsNotifier, AsyncValue<List<Gig>>>((ref) {
  final gigRepository = ref.watch(gigRepositoryProvider);
  return GigsNotifier(gigRepository);
});

/// Provider for user's own gigs
final userGigsProvider = FutureProvider<List<Gig>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];

  final gigRepository = ref.watch(gigRepositoryProvider);
  final result = await gigRepository.fetchUserGigs(user.id);

  return result.fold(
    (failure) {
      AppLogger.error('Failed to load user gigs', failure.message);
      throw Exception(failure.message);
    },
    (gigs) => gigs,
  );
});

/// Provider for a single gig by ID
final gigByIdProvider = FutureProvider.family<Gig, String>((ref, gigId) async {
  final gigRepository = ref.watch(gigRepositoryProvider);
  final result = await gigRepository.fetchGigById(gigId);

  return result.fold(
    (failure) {
      AppLogger.error('Failed to load gig', failure.message);
      throw Exception(failure.message);
    },
    (gig) => gig,
  );
});

/// State notifier for creating/editing a gig
class GigFormNotifier extends StateNotifier<AsyncValue<Gig?>> {
  final GigRepositoryImpl _gigRepository;
  final String _userId;

  GigFormNotifier(this._gigRepository, this._userId)
      : super(const AsyncValue.data(null));

  /// Create a new gig
  Future<bool> createGig({
    required String title,
    required String description,
    required double price,
    required double latitude,
    required double longitude,
    String? locationName,
  }) async {
    state = const AsyncValue.loading();

    final result = await _gigRepository.createGigWithUserId(
      userId: _userId,
      title: title,
      description: description,
      price: price,
      latitude: latitude,
      longitude: longitude,
      locationName: locationName,
    );

    return result.fold(
      (failure) {
        AppLogger.error('Failed to create gig', failure.message);
        state = AsyncValue.error(
          Exception(failure.message),
          StackTrace.current,
        );
        return false;
      },
      (gig) {
        state = AsyncValue.data(gig);
        return true;
      },
    );
  }

  /// Update an existing gig
  Future<bool> updateGig({
    required String gigId,
    String? title,
    String? description,
    double? price,
    double? latitude,
    double? longitude,
    String? locationName,
  }) async {
    state = const AsyncValue.loading();

    final result = await _gigRepository.updateGig(
      gigId: gigId,
      title: title,
      description: description,
      price: price,
      latitude: latitude,
      longitude: longitude,
      locationName: locationName,
    );

    return result.fold(
      (failure) {
        AppLogger.error('Failed to update gig', failure.message);
        state = AsyncValue.error(
          Exception(failure.message),
          StackTrace.current,
        );
        return false;
      },
      (gig) {
        state = AsyncValue.data(gig);
        return true;
      },
    );
  }

  /// Delete a gig
  Future<bool> deleteGig(String gigId) async {
    state = const AsyncValue.loading();

    final result = await _gigRepository.deleteGig(gigId);

    return result.fold(
      (failure) {
        AppLogger.error('Failed to delete gig', failure.message);
        state = AsyncValue.error(
          Exception(failure.message),
          StackTrace.current,
        );
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        return true;
      },
    );
  }
}

/// Provider for gig form operations
final gigFormProvider =
    StateNotifierProvider<GigFormNotifier, AsyncValue<Gig?>>((ref) {
  final gigRepository = ref.watch(gigRepositoryProvider) as GigRepositoryImpl;
  final user = ref.watch(currentUserProvider);
  return GigFormNotifier(gigRepository, user?.id ?? '');
});
