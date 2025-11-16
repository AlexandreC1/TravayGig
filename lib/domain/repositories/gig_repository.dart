import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/gig.dart';

/// Abstract repository interface for gig operations
/// Defines the contract for CRUD operations on gigs
abstract class GigRepository {
  /// Fetch all gigs (paginated)
  Future<Either<Failure, List<Gig>>> fetchGigs({
    int limit = 20,
    int offset = 0,
  });

  /// Fetch gigs by user ID
  Future<Either<Failure, List<Gig>>> fetchUserGigs(String userId);

  /// Fetch single gig by ID
  Future<Either<Failure, Gig>> fetchGigById(String gigId);

  /// Create a new gig
  Future<Either<Failure, Gig>> createGig({
    required String title,
    required String description,
    required double price,
    required double latitude,
    required double longitude,
    String? locationName,
  });

  /// Update existing gig
  Future<Either<Failure, Gig>> updateGig({
    required String gigId,
    String? title,
    String? description,
    double? price,
    double? latitude,
    double? longitude,
    String? locationName,
  });

  /// Delete gig
  Future<Either<Failure, void>> deleteGig(String gigId);

  /// Search gigs by query
  Future<Either<Failure, List<Gig>>> searchGigs(String query);

  /// Fetch gigs near a location
  Future<Either<Failure, List<Gig>>> fetchNearbyGigs({
    required double latitude,
    required double longitude,
    double radiusInKm = 10.0,
  });

  /// Stream of gig updates
  Stream<List<Gig>> gigsStream();
}
