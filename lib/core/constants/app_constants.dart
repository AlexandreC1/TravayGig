/// Application-wide constants
class AppConstants {
  // App Info
  static const String appName = 'KonbitWorks';
  static const String appTagline = 'Travay Gig pou Ayisyen';
  static const String appVersion = '1.0.0';

  // Currency
  static const String currency = 'HTG';
  static const String currencySymbol = 'G';

  // Pagination
  static const int gigsPerPage = 20;
  static const int maxGigsCache = 100;

  // Map Settings
  static const double defaultLatitude = 18.5944; // Port-au-Prince
  static const double defaultLongitude = -72.3074;
  static const double defaultZoom = 12.0;
  static const double markerClusterRadius = 120.0;

  // Geolocator Settings
  static const double locationAccuracy = 100.0; // meters
  static const int locationTimeoutSeconds = 10;

  // Cache Settings
  static const String gigsBoxName = 'gigs_cache';
  static const String userBoxName = 'user_cache';
  static const int cacheExpirationDays = 7;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Validation
  static const int minPasswordLength = 8;
  static const int maxTitleLength = 100;
  static const int maxDescriptionLength = 1000;
  static const double minPrice = 50.0; // HTG
  static const double maxPrice = 1000000.0; // HTG

  // Error Messages
  static const String networkError = 'Pwoblèm koneksyon. Tanpri verifye entènèt ou.';
  static const String unexpectedError = 'Yon erè rive. Tanpri eseye ankò.';
  static const String authError = 'Pwoblèm otantifikasyon. Tanpri konekte ankò.';
}
