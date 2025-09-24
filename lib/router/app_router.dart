// Go Router Configuration
import 'package:go_router/go_router.dart';
import 'package:lapinve/router/widgets/scaffold_with_navbar.dart';
import 'package:lapinve/screens/auth/login/login_screen.dart';
import 'package:lapinve/screens/favorites/favorites_page.dart';
import 'package:lapinve/screens/inbox/inbox_page.dart';
import 'package:lapinve/screens/more/more_page.dart';
import 'package:lapinve/screens/onboarding/onboarding_screen.dart';
import 'package:lapinve/screens/search/search_page.dart';
import 'package:lapinve/screens/splash_page.dart';
import 'package:lapinve/screens/trips/trips_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/onboarding', // Start with onboarding
  routes: [
    // Authentication routes (no bottom navigation)
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

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
