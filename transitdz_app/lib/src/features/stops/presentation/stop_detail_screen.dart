import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/models/departure.dart';
import '../../../core/models/transit_line.dart';
import '../../lines/presentation/line_detail_screen.dart';
import '../controllers/stop_detail_controller.dart';

class StopDetailScreen extends ConsumerWidget {
  const StopDetailScreen({super.key, required this.stopId});

  final String stopId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stopAsync = ref.watch(stopDetailProvider(stopId));
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('stops.next_arrivals')),
      ),
      body: stopAsync.when(
        data: (data) => ListView(
          padding: const EdgeInsets.only(bottom: 32),
          children: [
            SizedBox(
              height: 220,
              child: MapboxMap(
                accessToken: AppConstants.mapboxAccessToken,
                styleString: Theme.of(context).brightness == Brightness.dark
                    ? AppConstants.mapboxStyleDark
                    : AppConstants.mapboxStyleLight,
                initialCameraPosition: CameraPosition(
                  target: LatLng(data.stop.latitude, data.stop.longitude),
                  zoom: 14.5,
                ),
                rotateGesturesEnabled: false,
                tiltGesturesEnabled: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.stop.name,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    data.stop.address ?? data.stop.wilaya,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Theme.of(context).hintColor),
                  ),
                  const SizedBox(height: 24),
                  _SectionHeading(title: l10n.translate('stops.next_arrivals')),
                  const SizedBox(height: 12),
                  if (data.departures.isEmpty)
                    Text(l10n.translate('realtime.no_vehicles'))
                  else
                    ...data.departures
                        .map((departure) => _DepartureTile(departure: departure))
                        .toList(),
                  const SizedBox(height: 24),
                  _SectionHeading(title: l10n.translate('stops.lines')),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: data.lines
                        .map((line) => _LineChip(line: line))
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                  _SectionHeading(title: l10n.translate('stops.amenities')),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: data.stop.amenities
                        .map((amenity) => Chip(label: Text(amenity)))
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                  _SectionHeading(title: l10n.translate('stops.crowding')),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: LinearProgressIndicator(
                      minHeight: 16,
                      value: data.stop.crowdingLevel,
                      backgroundColor:
                          Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
      ),
    );
  }
}

class _DepartureTile extends StatelessWidget {
  const _DepartureTile({required this.departure});

  final Departure departure;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    Color statusColor;
    switch (departure.status) {
      case DepartureStatus.onTime:
        statusColor = colorScheme.primary;
        break;
      case DepartureStatus.delayed:
        statusColor = Colors.orangeAccent;
        break;
      case DepartureStatus.cancelled:
        statusColor = Colors.redAccent;
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Icons.directions_transit, color: statusColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    departure.line.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    departure.destination,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Theme.of(context).hintColor),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${departure.arrivalMinutes} min'),
                if (departure.platform != null)
                  Text(
                    AppLocalizations.of(context).translate('common.platform',
                        params: {'value': departure.platform!}),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LineChip extends ConsumerWidget {
  const _LineChip({required this.line});

  final TransitLine line;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = Color(int.parse(line.color.substring(1), radix: 16) + 0xFF000000);
    final textColor =
        Color(int.parse(line.textColor.substring(1), radix: 16) + 0xFF000000);
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => LineDetailScreen(lineId: line.id),
      )),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              line.name,
              style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style:
          Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}
