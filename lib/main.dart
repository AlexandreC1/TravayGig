import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/config/env_config.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/logger.dart';
import 'data/models/gig_cache_model.dart';
import 'presentation/router/app_router.dart';

/// Main entry point of the TravayGig application
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize environment configuration
    await EnvConfig.initialize();
    AppLogger.info('Environment configuration loaded');

    // Initialize Supabase
    await Supabase.initialize(
      url: EnvConfig.supabaseUrl,
      anonKey: EnvConfig.supabaseAnonKey,
    );
    AppLogger.info('Supabase initialized');

    // Initialize Hive for local caching
    await Hive.initFlutter();
    Hive.registerAdapter(GigCacheModelAdapter());
    await Hive.openBox<GigCacheModel>(AppConstants.gigsBoxName);
    AppLogger.info('Hive initialized');

    runApp(const ProviderScope(child: TravayGigApp()));
  } catch (e, stackTrace) {
    AppLogger.fatal('Failed to initialize app', e, stackTrace);
    runApp(ErrorApp(error: e.toString()));
  }
}

/// Main application widget
class TravayGigApp extends ConsumerWidget {
  const TravayGigApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}

/// Error application displayed when initialization fails
class ErrorApp extends StatelessWidget {
  final String error;

  const ErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Erè nan inisyalize aplikasyon an',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  error,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Tanpri verifye ou gen yon fichye .env avèk konfigirasyon ki kòrèk',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
