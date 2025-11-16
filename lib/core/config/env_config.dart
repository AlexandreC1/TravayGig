import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment configuration class for managing environment variables
/// Uses flutter_dotenv to securely load configuration without hardcoded values
class EnvConfig {
  /// Supabase project URL
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';

  /// Supabase anonymous key for client-side operations
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  /// Google Maps API key for Android platform
  static String get googleMapsApiKeyAndroid =>
      dotenv.env['GOOGLE_MAPS_API_KEY_ANDROID'] ?? '';

  /// Google Maps API key for iOS platform
  static String get googleMapsApiKeyIOS =>
      dotenv.env['GOOGLE_MAPS_API_KEY_IOS'] ?? '';

  /// Google Maps API key for Web platform
  static String get googleMapsApiKeyWeb =>
      dotenv.env['GOOGLE_MAPS_API_KEY_WEB'] ?? '';

  /// Current environment (dev, staging, prod)
  static String get environment => dotenv.env['ENVIRONMENT'] ?? 'dev';

  /// Check if all required environment variables are set
  static bool validateConfig() {
    return supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
  }

  /// Initialize environment configuration
  /// Should be called before runApp() in main.dart
  static Future<void> initialize() async {
    await dotenv.load(fileName: '.env');

    if (!validateConfig()) {
      throw Exception(
        'Missing required environment variables. '
        'Please check your .env file against .env.example',
      );
    }
  }
}
