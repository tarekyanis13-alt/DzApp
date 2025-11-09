import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/transit_alert.dart';
import '../../../core/models/transit_line.dart';
import '../../../core/models/transit_stop.dart';
import '../../../core/repository/transit_repository.dart';

final lineDetailProvider =
    FutureProvider.family<LineDetailData, String>((ref, lineId) async {
  final repository = ref.watch(transitRepositoryProvider);
  final line = await repository.getLineById(lineId);
  if (line == null) throw Exception('Line not found');
  final stops = await repository.getStops();
  final stopList = stops.where((stop) => line.stops.contains(stop.id)).toList();
  final alerts = await repository.getAlerts();
  final lineAlerts = alerts.where((alert) => alert.line?.id == line.id).toList();
  return LineDetailData(line: line, stops: stopList, alerts: lineAlerts);
});

class LineDetailData {
  LineDetailData({
    required this.line,
    required this.stops,
    required this.alerts,
  });

  final TransitLine line;
  final List<TransitStop> stops;
  final List<TransitAlert> alerts;
}
