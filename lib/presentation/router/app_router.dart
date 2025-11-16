import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/gig/create_gig_screen.dart';
import '../screens/gig/edit_gig_screen.dart';
import '../screens/gig/gig_detail_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../providers/auth_provider.dart';

/// Route paths
class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/';
  static const String createGig = '/gigs/create';
  static const String editGig = '/gigs/edit';
  static const String gigDetail = '/gigs';
  static const String profile = '/profile';
}

/// Router provider using GoRouter
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isAuthenticated = authState.value != null;
      final isLoading = authState.isLoading;
      final isGoingToLogin = state.matchedLocation == AppRoutes.login;
      final isGoingToSignup = state.matchedLocation == AppRoutes.signup;
      final isGoingToForgotPassword =
          state.matchedLocation == AppRoutes.forgotPassword;

      // Show loading while checking auth
      if (isLoading) {
        return null;
      }

      // Allow access to forgot password without authentication
      if (isGoingToForgotPassword) {
        return null;
      }

      // Redirect to login if not authenticated and not already going there
      if (!isAuthenticated && !isGoingToLogin && !isGoingToSignup) {
        return AppRoutes.login;
      }

      // Redirect to home if authenticated and going to login/signup
      if (isAuthenticated && (isGoingToLogin || isGoingToSignup)) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.signup,
        name: 'signup',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const SignupScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgotPassword',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const ForgotPasswordScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const HomeScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.createGig,
        name: 'createGig',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const CreateGigScreen(),
        ),
      ),
      GoRoute(
        path: '${AppRoutes.editGig}/:id',
        name: 'editGig',
        pageBuilder: (context, state) {
          final gigId = state.pathParameters['id']!;
          return MaterialPage(
            key: state.pageKey,
            child: EditGigScreen(gigId: gigId),
          );
        },
      ),
      GoRoute(
        path: '${AppRoutes.gigDetail}/:id',
        name: 'gigDetail',
        pageBuilder: (context, state) {
          final gigId = state.pathParameters['id']!;
          return MaterialPage(
            key: state.pageKey,
            child: GigDetailScreen(gigId: gigId),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const ProfileScreen(),
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Paj sa pa egziste',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(state.error.toString()),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Tounen lakay'),
            ),
          ],
        ),
      ),
    ),
  );
});
