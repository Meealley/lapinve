// Go Router Configuration
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lapinve/blocs/auth/auth_bloc.dart';
import 'package:lapinve/router/widgets/scaffold_with_navbar.dart';
import 'package:lapinve/screens/auth/login/login_screen.dart';
import 'package:lapinve/screens/auth/signup/signup_screen.dart';
import 'package:lapinve/screens/enhanced_splash_screen.dart';
import 'package:lapinve/screens/favorites/favorites_page.dart';
import 'package:lapinve/screens/inbox/inbox_page.dart';
import 'package:lapinve/screens/more/more_page.dart';
import 'package:lapinve/screens/onboarding/onboarding_screen.dart';
import 'package:lapinve/screens/search/search_page.dart';
import 'package:lapinve/screens/splash_page.dart';
import 'package:lapinve/screens/trips/trips_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/', // Start with onboarding

  redirect: (context, state) {
    // Get auth state from Bloc
    final authBloc = context.read<AuthBloc>();
    final authState = authBloc.state;

    final currentPath = state.matchedLocation;

    final isGoingToAuth =
        currentPath == '/login' ||
        currentPath == '/signup' ||
        currentPath == '/' ||
        currentPath == '/onboarding';

    // If user is authenticated and trying to go to auth pages, redirect to search
    if (authState.isAuthenticated && isGoingToAuth && currentPath != '/') {
      return '/search';
    }

    // If user is not authenticated and trying to access protected routes, redirect to login
    if (!authState.isAuthenticated &&
        !isGoingToAuth &&
        authState.status != AuthStatus.unknown) {
      return '/login';
    }
    return null;
  },
  routes: [
    GoRoute(path: "/", builder: (context, state) => const SplashScreen()),

    // Authentication routes (no bottom navigation)
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),

    // Main app routes (with bottom navigation)
    ShellRoute(
      builder: (context, state, child) {
        return ScaffoldWithNavbar(child: child);
      },
      routes: [
        GoRoute(
          path: '/search',
          builder: (context, state) => const SearchPage(),
        ),
        GoRoute(
          path: '/favorite',
          builder: (context, state) => const FavoritesPage(),
        ),
        GoRoute(path: '/trips', builder: (context, state) => const TripsPage()),
        GoRoute(path: '/inbox', builder: (context, state) => const InboxPage()),
        GoRoute(path: '/more', builder: (context, state) => const MorePage()),
      ],
    ),
  ],
);
