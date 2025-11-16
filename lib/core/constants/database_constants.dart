/// Database table and column name constants
/// Ensures type-safe references to Supabase schema
class DatabaseConstants {
  // Table Names
  static const String profilesTable = 'profiles';
  static const String gigsTable = 'gigs';

  // Profiles Table Columns
  static const String profileId = 'id';
  static const String profileEmail = 'email';
  static const String profileFullName = 'full_name';
  static const String profileAvatarUrl = 'avatar_url';
  static const String profileCreatedAt = 'created_at';
  static const String profileUpdatedAt = 'updated_at';

  // Gigs Table Columns
  static const String gigId = 'id';
  static const String gigUserId = 'user_id';
  static const String gigTitle = 'title';
  static const String gigDescription = 'description';
  static const String gigPrice = 'price';
  static const String gigLatitude = 'latitude';
  static const String gigLongitude = 'longitude';
  static const String gigLocationName = 'location_name';
  static const String gigCreatedAt = 'created_at';
  static const String gigUpdatedAt = 'updated_at';

  // Storage Buckets
  static const String avatarsBucket = 'avatars';
  static const String gigImagesBucket = 'gig_images';
}
