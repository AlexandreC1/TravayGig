import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/logger.dart';
import '../../domain/entities/location_data.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/location_datasource.dart';

/// Implementation of LocationRepository
class LocationRepositoryImpl implements LocationRepository {
  final LocationDataSource _dataSource;

  LocationRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, LocationData>> getCurrentLocation() async {
    try {
      final result = await _dataSource.getCurrentLocation();
      return Right(result.toEntity());
    } on LocationException catch (e) {
      AppLogger.error('Location error in getCurrentLocation', e);
      return Left(LocationFailure(e.message));
    } on PermissionException catch (e) {
      AppLogger.error('Permission error in getCurrentLocation', e);
      return Left(PermissionFailure(e.message));
    } catch (e) {
      AppLogger.error('Unexpected error in getCurrentLocation', e);
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isLocationServiceEnabled() async {
    try {
      final result = await _dataSource.isLocationServiceEnabled();
      return Right(result);
    } catch (e) {
      AppLogger.error('Error in isLocationServiceEnabled', e);
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> requestLocationPermission() async {
    try {
      final result = await _dataSource.requestLocationPermission();
      return Right(result);
    } catch (e) {
      AppLogger.error('Error in requestLocationPermission', e);
      return Left(PermissionFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkLocationPermission() async {
    try {
      final result = await _dataSource.checkLocationPermission();
      return Right(result);
    } catch (e) {
      AppLogger.error('Error in checkLocationPermission', e);
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getAddressFromCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final result = await _dataSource.getAddressFromCoordinates(
        latitude: latitude,
        longitude: longitude,
      );
      return Right(result);
    } on LocationException catch (e) {
      AppLogger.error('Location error in getAddressFromCoordinates', e);
      return Left(LocationFailure(e.message));
    } catch (e) {
      AppLogger.error('Unexpected error in getAddressFromCoordinates', e);
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LocationData>> getCoordinatesFromAddress(
    String address,
  ) async {
    try {
      final result = await _dataSource.getCoordinatesFromAddress(address);
      return Right(result.toEntity());
    } on LocationException catch (e) {
      AppLogger.error('Location error in getCoordinatesFromAddress', e);
      return Left(LocationFailure(e.message));
    } catch (e) {
      AppLogger.error('Unexpected error in getCoordinatesFromAddress', e);
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
