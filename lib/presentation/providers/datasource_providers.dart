import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../core/constants/app_constants.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/datasources/gig_local_datasource.dart';
import '../../data/datasources/gig_remote_datasource.dart';
import '../../data/datasources/location_datasource.dart';
import '../../data/models/gig_cache_model.dart';
import 'supabase_provider.dart';

/// Provider for AuthRemoteDataSource
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return AuthRemoteDataSource(supabase);
});

/// Provider for GigRemoteDataSource
final gigRemoteDataSourceProvider = Provider<GigRemoteDataSource>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return GigRemoteDataSource(supabase);
});

/// Provider for GigLocalDataSource
final gigLocalDataSourceProvider = Provider<GigLocalDataSource>((ref) {
  final box = Hive.box<GigCacheModel>(AppConstants.gigsBoxName);
  return GigLocalDataSource(box);
});

/// Provider for LocationDataSource
final locationDataSourceProvider = Provider<LocationDataSource>((ref) {
  return LocationDataSource();
});
