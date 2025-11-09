import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/models/transit_route.dart';
import '../../../core/models/transit_stop.dart';
import 'route_planner_screen.dart';

class RouteResultsScreen extends StatelessWidget {
  const RouteResultsScreen({super.key, required this.args});

  final RoutePlannerResultArgs args;

  @override
  Widget build(BuildContext context) {
    final option = args.option;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('planner.details')),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        itemCount: option.steps.length,
        itemBuilder: (context, index) {
          final step = option.steps[index];
          return TimelineTile(
            isFirst: index == 0,
            isLast: index == option.steps.length - 1,
            indicatorStyle: IndicatorStyle(
              width: 32,
              height: 32,
              color: Theme.of(context).colorScheme.primary,
              iconStyle: IconStyle(
                iconData: _iconForStep(step.type),
                color: Colors.white,
              ),
            ),
            beforeLineStyle: LineStyle(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
            ),
            endChild: _RouteStepCard(step: step),
          );
        },
      ),
    );
  }

  IconData _iconForStep(StepType type) {
    return switch (type) {
      StepType.walk => Icons.directions_walk,
      StepType.ride => Icons.directions_transit,
      StepType.transfer => Icons.transfer_within_a_station,
    };
  }
}

class _RouteStepCard extends StatelessWidget {
  const _RouteStepCard({required this.step});

  final TransitRouteStep step;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              step.description,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${step.durationMinutes} min',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Theme.of(context).hintColor),
            ),
            if (step.line != null) ...[
              const SizedBox(height: 12),
              _LineChip(
                label: step.line!.name,
                color: step.line!.color,
                textColor: step.line!.textColor,
              ),
            ],
            if (step.from != null || step.to != null) ...[
              const SizedBox(height: 12),
              _StopInfoRow(
                title: AppLocalizations.of(context).translate('planner.from'),
                stop: step.from,
              ),
              const SizedBox(height: 6),
              _StopInfoRow(
                title: AppLocalizations.of(context).translate('planner.to'),
                stop: step.to,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LineChip extends StatelessWidget {
  const _LineChip({
    required this.label,
    required this.color,
    required this.textColor,
  });

  final String label;
  final String color;
  final String textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Color(int.parse(color.substring(1), radix: 16) + 0xFF000000),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Color(int.parse(textColor.substring(1), radix: 16) + 0xFF000000),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _StopInfoRow extends StatelessWidget {
  const _StopInfoRow({required this.title, required this.stop});

  final String title;
  final TransitStop? stop;

  @override
  Widget build(BuildContext context) {
    if (stop == null) {
      return const SizedBox.shrink();
    }
    return Row(
      children: [
        Text(
          '$title: ',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        Expanded(
          child: Text(
            stop!.name,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
