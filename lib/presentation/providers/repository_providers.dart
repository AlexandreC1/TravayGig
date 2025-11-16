import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/gig_repository_impl.dart';
import '../../data/repositories/location_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/gig_repository.dart';
import '../../domain/repositories/location_repository.dart';
import 'datasource_providers.dart';

/// Provider for AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource);
});

/// Provider for GigRepository
final gigRepositoryProvider = Provider<GigRepository>((ref) {
  final remoteDataSource = ref.watch(gigRemoteDataSourceProvider);
  final localDataSource = ref.watch(gigLocalDataSourceProvider);
  return GigRepositoryImpl(remoteDataSource, localDataSource);
});

/// Provider for LocationRepository
final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  final dataSource = ref.watch(locationDataSourceProvider);
  return LocationRepositoryImpl(dataSource);
});
