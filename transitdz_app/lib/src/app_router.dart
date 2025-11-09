import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/localization/app_localizations.dart';
import 'features/common/presentation/error_screen.dart';
import 'features/favorites/presentation/favorites_screen.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/lines/presentation/line_detail_screen.dart';
import 'features/map/presentation/map_screen.dart';
import 'features/onboarding/controllers/onboarding_controller.dart';
import 'features/onboarding/presentation/onboarding_screen.dart';
import 'features/planner/presentation/route_planner_screen.dart';
import 'features/planner/presentation/route_results_screen.dart';
import 'features/realtime/presentation/realtime_tracker_screen.dart';
import 'features/settings/presentation/settings_screen.dart';
import 'features/stops/presentation/stop_detail_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final completed = ref.watch(onboardingCompletedProvider);
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: completed ? '/home' : '/onboarding',
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/map',
        builder: (context, state) => const MapScreen(),
      ),
      GoRoute(
        path: '/planner',
        builder: (context, state) => const RoutePlannerScreen(),
      ),
      GoRoute(
        path: '/planner/results',
        builder: (context, state) {
          final args = state.extra as RoutePlannerResultArgs?;
          if (args == null) {
            return const ErrorScreen();
          }
          return RouteResultsScreen(args: args);
        },
      ),
      GoRoute(
        path: '/realtime',
        builder: (context, state) => const RealtimeTrackerScreen(),
      ),
      GoRoute(
        path: '/favorites',
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/stops/:stopId',
        builder: (context, state) {
          final stopId = state.pathParameters['stopId'];
          if (stopId == null) {
            return const ErrorScreen();
          }
          return StopDetailScreen(stopId: stopId);
        },
      ),
      GoRoute(
        path: '/lines/:lineId',
        builder: (context, state) {
          final lineId = state.pathParameters['lineId'];
          if (lineId == null) {
            return const ErrorScreen();
          }
          return LineDetailScreen(lineId: lineId);
        },
      ),
    ],
    redirect: (context, state) {
      final onboardingRoute = state.matchedLocation == '/onboarding';
      if (!completed && !onboardingRoute) {
        return '/onboarding';
      }
      if (completed && onboardingRoute) {
        return '/home';
      }
      return null;
    },
    errorBuilder: (context, state) => ErrorScreen(message: state.error.toString()),
  );
});
