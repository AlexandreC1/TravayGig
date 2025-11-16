import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/logger.dart';
import '../../domain/entities/location_data.dart';
import '../../domain/repositories/location_repository.dart';
import 'repository_providers.dart';

/// State notifier for location
class LocationNotifier extends StateNotifier<AsyncValue<LocationData?>> {
  final LocationRepository _locationRepository;

  LocationNotifier(this._locationRepository)
      : super(const AsyncValue.data(null));

  /// Get current location
  Future<void> getCurrentLocation() async {
    state = const AsyncValue.loading();

    final result = await _locationRepository.getCurrentLocation();

    result.fold(
      (failure) {
        AppLogger.error('Failed to get current location', failure.message);
        state = AsyncValue.error(
          Exception(failure.message),
          StackTrace.current,
        );
      },
      (location) {
        state = AsyncValue.data(location);
      },
    );
  }

  /// Request location permission
  Future<bool> requestPermission() async {
    final result = await _locationRepository.requestLocationPermission();

    return result.fold(
      (failure) {
        AppLogger.error('Failed to request permission', failure.message);
        return false;
      },
      (granted) => granted,
    );
  }

  /// Check if location service is enabled
  Future<bool> checkServiceEnabled() async {
    final result = await _locationRepository.isLocationServiceEnabled();

    return result.fold(
      (failure) => false,
      (enabled) => enabled,
    );
  }

  /// Get address from coordinates
  Future<String?> getAddress(double latitude, double longitude) async {
    final result = await _locationRepository.getAddressFromCoordinates(
      latitude: latitude,
      longitude: longitude,
    );

    return result.fold(
      (failure) {
        AppLogger.error('Failed to get address', failure.message);
        return null;
      },
      (address) => address,
    );
  }

  /// Clear location
  void clearLocation() {
    state = const AsyncValue.data(null);
  }
}

/// Provider for location state
final locationProvider =
    StateNotifierProvider<LocationNotifier, AsyncValue<LocationData?>>((ref) {
  final locationRepository = ref.watch(locationRepositoryProvider);
  return LocationNotifier(locationRepository);
});
