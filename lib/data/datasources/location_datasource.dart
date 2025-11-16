import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/utils/logger.dart';
import '../models/location_data_model.dart';

/// Data source for location services using Geolocator and Geocoding
class LocationDataSource {
  /// Get current device location
  Future<LocationDataModel> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw LocationException('Location services are disabled');
      }

      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw PermissionException('Location permission denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw PermissionException(
          'Location permission permanently denied',
        );
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(
          seconds: AppConstants.locationTimeoutSeconds,
        ),
      );

      // Try to get address (optional, non-blocking)
      String? address;
      try {
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          final placemark = placemarks.first;
          address = [
            placemark.street,
            placemark.locality,
            placemark.country,
          ].where((e) => e != null && e.isNotEmpty).join(', ');
        }
      } catch (e) {
        AppLogger.warning('Failed to get address for current location', e);
      }

      return LocationDataModel(
        latitude: position.latitude,
        longitude: position.longitude,
        address: address,
        accuracy: position.accuracy,
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error getting current location', e, stackTrace);
      if (e is LocationException || e is PermissionException) {
        rethrow;
      }
      throw LocationException('Failed to get current location: $e');
    }
  }

  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    try {
      return await Geolocator.isLocationServiceEnabled();
    } catch (e, stackTrace) {
      AppLogger.error('Error checking location service', e, stackTrace);
      return false;
    }
  }

  /// Request location permission
  Future<bool> requestLocationPermission() async {
    try {
      final permission = await Geolocator.requestPermission();
      return permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
    } catch (e, stackTrace) {
      AppLogger.error('Error requesting location permission', e, stackTrace);
      return false;
    }
  }

  /// Check location permission status
  Future<bool> checkLocationPermission() async {
    try {
      final permission = await Geolocator.checkPermission();
      return permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
    } catch (e, stackTrace) {
      AppLogger.error('Error checking location permission', e, stackTrace);
      return false;
    }
  }

  /// Get address from coordinates (reverse geocoding)
  Future<String> getAddressFromCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isEmpty) {
        throw LocationException('No address found for coordinates');
      }

      final placemark = placemarks.first;
      return [
        placemark.street,
        placemark.locality,
        placemark.administrativeArea,
        placemark.country,
      ].where((e) => e != null && e.isNotEmpty).join(', ');
    } catch (e, stackTrace) {
      AppLogger.error('Error getting address from coordinates', e, stackTrace);
      throw LocationException('Failed to get address: $e');
    }
  }

  /// Get coordinates from address (geocoding)
  Future<LocationDataModel> getCoordinatesFromAddress(String address) async {
    try {
      final locations = await locationFromAddress(address);

      if (locations.isEmpty) {
        throw LocationException('No coordinates found for address');
      }

      final location = locations.first;
      return LocationDataModel(
        latitude: location.latitude,
        longitude: location.longitude,
        address: address,
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error getting coordinates from address', e, stackTrace);
      throw LocationException('Failed to get coordinates: $e');
    }
  }
}
