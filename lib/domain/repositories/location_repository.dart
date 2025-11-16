import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/location_data.dart';

/// Abstract repository interface for location services
abstract class LocationRepository {
  /// Get current device location
  Future<Either<Failure, LocationData>> getCurrentLocation();

  /// Check if location services are enabled
  Future<Either<Failure, bool>> isLocationServiceEnabled();

  /// Request location permission
  Future<Either<Failure, bool>> requestLocationPermission();

  /// Check location permission status
  Future<Either<Failure, bool>> checkLocationPermission();

  /// Get address from coordinates (reverse geocoding)
  Future<Either<Failure, String>> getAddressFromCoordinates({
    required double latitude,
    required double longitude,
  });

  /// Get coordinates from address (geocoding)
  Future<Either<Failure, LocationData>> getCoordinatesFromAddress(
    String address,
  );
}
