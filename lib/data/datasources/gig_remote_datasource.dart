import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/database_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/utils/logger.dart';
import '../models/gig_model.dart';

/// Remote data source for gig operations using Supabase
class GigRemoteDataSource {
  final SupabaseClient _supabase;

  GigRemoteDataSource(this._supabase);

  /// Fetch all gigs with pagination
  /// Joins with profiles table to get user information
  Future<List<GigModel>> fetchGigs({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await _supabase
          .from(DatabaseConstants.gigsTable)
          .select('''
            *,
            ${DatabaseConstants.profilesTable}!inner(
              ${DatabaseConstants.profileFullName},
              ${DatabaseConstants.profileAvatarUrl}
            )
          ''')
          .order(DatabaseConstants.gigCreatedAt, ascending: false)
          .range(offset, offset + limit - 1);

      return (response as List)
          .map((json) => _mapGigWithProfile(json))
          .toList();
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching gigs', e, stackTrace);
      throw ServerException('Failed to fetch gigs: $e');
    }
  }

  /// Fetch gigs created by specific user
  Future<List<GigModel>> fetchUserGigs(String userId) async {
    try {
      final response = await _supabase
          .from(DatabaseConstants.gigsTable)
          .select('''
            *,
            ${DatabaseConstants.profilesTable}!inner(
              ${DatabaseConstants.profileFullName},
              ${DatabaseConstants.profileAvatarUrl}
            )
          ''')
          .eq(DatabaseConstants.gigUserId, userId)
          .order(DatabaseConstants.gigCreatedAt, ascending: false);

      return (response as List)
          .map((json) => _mapGigWithProfile(json))
          .toList();
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching user gigs', e, stackTrace);
      throw ServerException('Failed to fetch user gigs: $e');
    }
  }

  /// Fetch single gig by ID
  Future<GigModel> fetchGigById(String gigId) async {
    try {
      final response = await _supabase
          .from(DatabaseConstants.gigsTable)
          .select('''
            *,
            ${DatabaseConstants.profilesTable}!inner(
              ${DatabaseConstants.profileFullName},
              ${DatabaseConstants.profileAvatarUrl}
            )
          ''')
          .eq(DatabaseConstants.gigId, gigId)
          .single();

      return _mapGigWithProfile(response);
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching gig by ID', e, stackTrace);
      throw ServerException('Failed to fetch gig: $e');
    }
  }

  /// Create new gig
  Future<GigModel> createGig({
    required String userId,
    required String title,
    required String description,
    required double price,
    required double latitude,
    required double longitude,
    String? locationName,
  }) async {
    try {
      final gigData = {
        DatabaseConstants.gigUserId: userId,
        DatabaseConstants.gigTitle: title,
        DatabaseConstants.gigDescription: description,
        DatabaseConstants.gigPrice: price,
        DatabaseConstants.gigLatitude: latitude,
        DatabaseConstants.gigLongitude: longitude,
        DatabaseConstants.gigLocationName: locationName,
        DatabaseConstants.gigCreatedAt: DateTime.now().toIso8601String(),
      };

      final response = await _supabase
          .from(DatabaseConstants.gigsTable)
          .insert(gigData)
          .select('''
            *,
            ${DatabaseConstants.profilesTable}!inner(
              ${DatabaseConstants.profileFullName},
              ${DatabaseConstants.profileAvatarUrl}
            )
          ''')
          .single();

      return _mapGigWithProfile(response);
    } catch (e, stackTrace) {
      AppLogger.error('Error creating gig', e, stackTrace);
      throw ServerException('Failed to create gig: $e');
    }
  }

  /// Update existing gig
  Future<GigModel> updateGig({
    required String gigId,
    String? title,
    String? description,
    double? price,
    double? latitude,
    double? longitude,
    String? locationName,
  }) async {
    try {
      final updateData = <String, dynamic>{
        DatabaseConstants.gigUpdatedAt: DateTime.now().toIso8601String(),
      };

      if (title != null) updateData[DatabaseConstants.gigTitle] = title;
      if (description != null) {
        updateData[DatabaseConstants.gigDescription] = description;
      }
      if (price != null) updateData[DatabaseConstants.gigPrice] = price;
      if (latitude != null) {
        updateData[DatabaseConstants.gigLatitude] = latitude;
      }
      if (longitude != null) {
        updateData[DatabaseConstants.gigLongitude] = longitude;
      }
      if (locationName != null) {
        updateData[DatabaseConstants.gigLocationName] = locationName;
      }

      final response = await _supabase
          .from(DatabaseConstants.gigsTable)
          .update(updateData)
          .eq(DatabaseConstants.gigId, gigId)
          .select('''
            *,
            ${DatabaseConstants.profilesTable}!inner(
              ${DatabaseConstants.profileFullName},
              ${DatabaseConstants.profileAvatarUrl}
            )
          ''')
          .single();

      return _mapGigWithProfile(response);
    } catch (e, stackTrace) {
      AppLogger.error('Error updating gig', e, stackTrace);
      throw ServerException('Failed to update gig: $e');
    }
  }

  /// Delete gig
  Future<void> deleteGig(String gigId) async {
    try {
      await _supabase
          .from(DatabaseConstants.gigsTable)
          .delete()
          .eq(DatabaseConstants.gigId, gigId);
    } catch (e, stackTrace) {
      AppLogger.error('Error deleting gig', e, stackTrace);
      throw ServerException('Failed to delete gig: $e');
    }
  }

  /// Search gigs by title or description
  Future<List<GigModel>> searchGigs(String query) async {
    try {
      final response = await _supabase
          .from(DatabaseConstants.gigsTable)
          .select('''
            *,
            ${DatabaseConstants.profilesTable}!inner(
              ${DatabaseConstants.profileFullName},
              ${DatabaseConstants.profileAvatarUrl}
            )
          ''')
          .or(
            '${DatabaseConstants.gigTitle}.ilike.%$query%,'
            '${DatabaseConstants.gigDescription}.ilike.%$query%',
          )
          .order(DatabaseConstants.gigCreatedAt, ascending: false);

      return (response as List)
          .map((json) => _mapGigWithProfile(json))
          .toList();
    } catch (e, stackTrace) {
      AppLogger.error('Error searching gigs', e, stackTrace);
      throw ServerException('Failed to search gigs: $e');
    }
  }

  /// Stream of gig changes
  Stream<List<GigModel>> gigsStream() {
    return _supabase
        .from(DatabaseConstants.gigsTable)
        .stream(primaryKey: [DatabaseConstants.gigId])
        .order(DatabaseConstants.gigCreatedAt, ascending: false)
        .map((data) => data.map((json) => GigModel.fromJson(json)).toList());
  }

  /// Helper method to map gig data with joined profile
  GigModel _mapGigWithProfile(Map<String, dynamic> json) {
    final profileData = json[DatabaseConstants.profilesTable];

    return GigModel(
      id: json[DatabaseConstants.gigId],
      userId: json[DatabaseConstants.gigUserId],
      title: json[DatabaseConstants.gigTitle],
      description: json[DatabaseConstants.gigDescription],
      price: (json[DatabaseConstants.gigPrice] as num).toDouble(),
      latitude: (json[DatabaseConstants.gigLatitude] as num).toDouble(),
      longitude: (json[DatabaseConstants.gigLongitude] as num).toDouble(),
      locationName: json[DatabaseConstants.gigLocationName],
      createdAt: DateTime.parse(json[DatabaseConstants.gigCreatedAt]),
      updatedAt: json[DatabaseConstants.gigUpdatedAt] != null
          ? DateTime.parse(json[DatabaseConstants.gigUpdatedAt])
          : null,
      userFullName: profileData?[DatabaseConstants.profileFullName],
      userAvatarUrl: profileData?[DatabaseConstants.profileAvatarUrl],
    );
  }
}
