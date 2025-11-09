import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/transit_alert.dart';
import '../../../core/models/transit_route.dart';
import '../../../core/models/transit_stop.dart';
import '../../../core/repository/transit_repository.dart';

final homeDashboardProvider = FutureProvider<HomeDashboardData>((ref) async {
  final repository = ref.watch(transitRepositoryProvider);
  final stops = await repository.getStops();
  final alerts = await repository.getAlerts();
  final routes = await repository.getRouteOptions();
  return HomeDashboardData(
    featuredStops: stops.take(4).toList(),
    activeAlerts: alerts,
    suggestedRoutes: routes,
  );
});

class HomeDashboardData {
  HomeDashboardData({
    required this.featuredStops,
    required this.activeAlerts,
    required this.suggestedRoutes,
  });

  final List<TransitStop> featuredStops;
  final List<TransitAlert> activeAlerts;
  final List<TransitRouteOption> suggestedRoutes;
}
