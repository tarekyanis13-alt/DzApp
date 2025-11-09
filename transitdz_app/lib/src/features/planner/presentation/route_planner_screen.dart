import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/models/transit_route.dart';
import '../../../core/repository/transit_repository.dart';

class RoutePlannerScreen extends ConsumerStatefulWidget {
  const RoutePlannerScreen({super.key});

  @override
  ConsumerState<RoutePlannerScreen> createState() => _RoutePlannerScreenState();
}

class _RoutePlannerScreenState extends ConsumerState<RoutePlannerScreen> {
  final _fromController = TextEditingController(text: 'Place Audin, Algiers');
  final _toController = TextEditingController(text: 'Bordj El Kiffan');
  RouteOptimization _optimization = RouteOptimization.fastest;
  List<TransitRouteOption> _results = [];
  bool _loading = false;

  Future<void> _plan() async {
    setState(() => _loading = true);
    final repository = ref.read(transitRepositoryProvider);
    final routes = await repository.getRouteOptions();
    setState(() {
      _results = routes
          .where((route) => route.optimization == _optimization)
          .toList();
      if (_results.isEmpty) {
        _results = routes;
      }
      _loading = false;
    });
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('planner.title')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PlannerInputField(
              controller: _fromController,
              label: l10n.translate('planner.from'),
              icon: Icons.trip_origin,
            ),
            const SizedBox(height: 16),
            _PlannerInputField(
              controller: _toController,
              label: l10n.translate('planner.to'),
              icon: Icons.flag,
            ),
            const SizedBox(height: 20),
            Text(
              l10n.translate('planner.options'),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SegmentedButton<RouteOptimization>(
              segments: [
                ButtonSegment(
                  value: RouteOptimization.fastest,
                  label: Text(l10n.translate('planner.fastest')),
                  icon: const Icon(Icons.bolt),
                ),
                ButtonSegment(
                  value: RouteOptimization.leastWalking,
                  label: Text(l10n.translate('planner.least_walking')),
                  icon: const Icon(Icons.directions_walk),
                ),
                ButtonSegment(
                  value: RouteOptimization.cheapest,
                  label: Text(l10n.translate('planner.cheapest')),
                  icon: const Icon(Icons.savings_outlined),
                ),
              ],
              selected: {_optimization},
              onSelectionChanged: (selection) {
                setState(() => _optimization = selection.first);
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _loading ? null : _plan,
                icon: _loading
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.directions_transit),
                label: Text(l10n.translate('home.plan_trip')),
              ),
            ),
            const SizedBox(height: 24),
            if (_results.isNotEmpty)
              ..._results.map((route) => _RouteResultTile(option: route)).toList(),
          ],
        ),
      ),
    );
  }
}

class _PlannerInputField extends StatelessWidget {
  const _PlannerInputField({
    required this.controller,
    required this.label,
    required this.icon,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _RouteResultTile extends ConsumerWidget {
  const _RouteResultTile({required this.option});

  final TransitRouteOption option;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => context.push('/planner/results',
            extra: RoutePlannerResultArgs(option: option)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.route, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 12),
                  Text(
                    option.optimization.name.toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text('${option.totalDurationMinutes} min'),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                l10n.translate('planner.summary', params: {
                  'duration': '${option.totalDurationMinutes} min',
                  'transfers': option.transfers.toString(),
                  'arrival': TimeOfDay.fromDateTime(option.arrivalTime).format(context),
                }),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Theme.of(context).hintColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoutePlannerResultArgs {
  RoutePlannerResultArgs({required this.option});

  final TransitRouteOption option;
}
