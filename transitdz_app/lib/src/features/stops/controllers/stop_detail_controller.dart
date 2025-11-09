import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/departure.dart';
import '../../../core/models/transit_line.dart';
import '../../../core/models/transit_stop.dart';
import '../../../core/repository/transit_repository.dart';

final stopDetailProvider =
    FutureProvider.family<StopDetailData, String>((ref, stopId) async {
  final repository = ref.watch(transitRepositoryProvider);
  final stop = await repository.getStopById(stopId);
  final departures = await repository.getDepartures();
  final lines = await repository.getLines();
  if (stop == null) {
    throw Exception('Stop not found');
  }
  final servingLines = lines.where((line) => line.stops.contains(stop.id)).toList();
  final upcoming = departures.where((dep) => dep.stopId == stop.id).toList();
  return StopDetailData(stop: stop, departures: upcoming, lines: servingLines);
});

class StopDetailData {
  StopDetailData({
    required this.stop,
    required this.departures,
    required this.lines,
  });

  final TransitStop stop;
  final List<Departure> departures;
  final List<TransitLine> lines;
}
