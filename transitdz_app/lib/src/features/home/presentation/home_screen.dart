import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/models/transit_alert.dart';
import '../../../core/models/transit_route.dart';
import '../../../core/models/transit_stop.dart';
import '../../planner/presentation/route_planner_screen.dart';
import '../controllers/home_dashboard_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(homeDashboardProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.translate('app.name')),
            Text(
              l10n.translate('app.tagline'),
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_outline),
            onPressed: () => context.go('/favorites'),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: dashboardAsync.when(
        data: (data) => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SearchCard(onTapPlanner: () => context.go('/planner')),
                    const SizedBox(height: 20),
                    _MapPreviewCard(onOpenMap: () => context.go('/map')),
                    const SizedBox(height: 20),
                    _SectionTitle(text: l10n.translate('home.next_departures')),
                    const SizedBox(height: 12),
                    ...data.featuredStops
                        .map((stop) => _StopCard(stop: stop))
                        .toList(),
                    const SizedBox(height: 24),
                    _SectionTitle(text: l10n.translate('home.live_updates')),
                    const SizedBox(height: 12),
                    if (data.activeAlerts.isEmpty)
                      _InfoCard(message: l10n.translate('realtime.no_vehicles'))
                    else
                      ...data.activeAlerts
                          .map((alert) => _AlertCard(alert: alert))
                          .toList(),
                    const SizedBox(height: 24),
                    _SectionTitle(text: l10n.translate('planner.results_title')),
                    const SizedBox(height: 12),
                    ...data.suggestedRoutes
                        .map((route) => _RouteCard(
                              option: route,
                              onTap: () => context.push('/planner/results',
                                  extra: RoutePlannerResultArgs(option: route)),
                            ))
                        .toList(),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ],
        ).animate().fadeIn(duration: 450.ms),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('${AppLocalizations.of(context).translate('common.error')}: $error'),
        ),
      ),
    );
  }
}

class _SearchCard extends StatelessWidget {
  const _SearchCard({required this.onTapPlanner});

  final VoidCallback onTapPlanner;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GestureDetector(
      onTap: onTapPlanner,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          children: [
            Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.translate('home.search_hint'),
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Theme.of(context).hintColor),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(Icons.schedule,
                      color: Theme.of(context).colorScheme.primary, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    l10n.translate('planner.leave_now'),
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapPreviewCard extends StatelessWidget {
  const _MapPreviewCard({required this.onOpenMap});

  final VoidCallback onOpenMap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: SizedBox(
            height: 220,
            child: MapboxMap(
              accessToken: AppConstants.mapboxAccessToken,
              styleString: Theme.of(context).brightness == Brightness.dark
                  ? AppConstants.mapboxStyleDark
                  : AppConstants.mapboxStyleLight,
              initialCameraPosition: const CameraPosition(
                target: LatLng(36.7538, 3.0588),
                zoom: 11.5,
              ),
              rotateGesturesEnabled: false,
              tiltGesturesEnabled: false,
              zoomGesturesEnabled: false,
              scrollGesturesEnabled: false,
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: ElevatedButton.icon(
            onPressed: onOpenMap,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            icon: const Icon(Icons.map_outlined),
            label: Text(AppLocalizations.of(context).translate('home.open_map')),
          ),
        )
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

class _StopCard extends StatelessWidget {
  const _StopCard({required this.stop});

  final TransitStop stop;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => GoRouter.of(context).push('/stops/${stop.id}') ,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                  ),
                  child: const Icon(Icons.directions_transit),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stop.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        stop.wilaya,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Theme.of(context).hintColor),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({required this.alert});

  final TransitAlert alert;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = switch (alert.severity) {
      AlertSeverity.severe => Colors.redAccent,
      AlertSeverity.warning => Colors.amber,
      AlertSeverity.info => colorScheme.primary,
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: color.withOpacity(0.12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning_amber, color: color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    alert.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(alert.message,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(20),
      child: Text(
        message,
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: Theme.of(context).hintColor),
      ),
    );
  }
}

class _RouteCard extends StatelessWidget {
  const _RouteCard({required this.option, required this.onTap});

  final TransitRouteOption option;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final duration = l10n.translate('planner.summary', params: {
      'duration': '${option.totalDurationMinutes} min',
      'transfers': option.transfers.toString(),
      'arrival': TimeOfDay.fromDateTime(option.arrivalTime).format(context),
    });

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.route,
                        color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 12),
                    Text(
                      option.optimization.name.toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Text(
                      '${option.costDZD.toStringAsFixed(0)} DZD',
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(color: Theme.of(context).colorScheme.primary),
                    )
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  duration,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Theme.of(context).hintColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
