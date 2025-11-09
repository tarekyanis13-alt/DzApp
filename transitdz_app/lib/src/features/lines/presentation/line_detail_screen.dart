import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/models/transit_line.dart';
import '../../../core/models/transit_stop.dart';
import '../controllers/line_detail_controller.dart';

class LineDetailScreen extends ConsumerWidget {
  const LineDetailScreen({super.key, required this.lineId});

  final String lineId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lineAsync = ref.watch(lineDetailProvider(lineId));
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('lines.alerts')),
      ),
      body: lineAsync.when(
        data: (data) => ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            _LineHero(line: data.line),
            const SizedBox(height: 24),
            Text(
              l10n.translate('lines.operating_hours'),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(data.line.operatingHours),
            const SizedBox(height: 16),
            Text(
              l10n.translate('lines.frequency', params: {
                'value': data.line.frequencyMinutes['peak']?.toString() ?? '--',
              }),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.translate('lines.stops'),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...data.stops.map((stop) => _StopTile(stop: stop)).toList(),
            const SizedBox(height: 24),
            Text(
              l10n.translate('lines.alerts'),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (data.alerts.isEmpty)
              Text(l10n.translate('realtime.no_vehicles'))
            else
              ...data.alerts.map((alert) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.warning_amber_rounded),
                      title: Text(alert.title),
                      subtitle: Text(alert.message),
                    ),
                  )),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
      ),
    );
  }
}

class _LineHero extends StatelessWidget {
  const _LineHero({required this.line});

  final TransitLine line;

  @override
  Widget build(BuildContext context) {
    final color = Color(int.parse(line.color.substring(1), radix: 16) + 0xFF000000);
    final textColor =
        Color(int.parse(line.textColor.substring(1), radix: 16) + 0xFF000000);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [color.withOpacity(0.9), color.withOpacity(0.6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            line.code,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(color: textColor, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            line.name,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: textColor.withOpacity(0.9)),
          ),
          const SizedBox(height: 12),
          Text(
            line.description ?? '',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: textColor.withOpacity(0.8)),
          )
        ],
      ),
    );
  }
}

class _StopTile extends StatelessWidget {
  const _StopTile({required this.stop});

  final TransitStop stop;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        leading: const Icon(Icons.place_outlined),
        title: Text(stop.name),
        subtitle: Text(stop.wilaya),
      ),
    );
  }
}
