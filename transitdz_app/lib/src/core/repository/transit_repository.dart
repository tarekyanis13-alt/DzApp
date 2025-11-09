import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/departure.dart';
import '../models/transit_alert.dart';
import '../models/transit_line.dart';
import '../models/transit_route.dart';
import '../models/transit_stop.dart';
import '../models/vehicle_position.dart';
import '../services/mock_transit_data_source.dart';

final transitRepositoryProvider = Provider<TransitRepository>((ref) {
  return TransitRepository(MockTransitDataSource());
});

class TransitRepository {
  TransitRepository(this._dataSource);

  final MockTransitDataSource _dataSource;

  Future<List<TransitStop>> getStops() => _dataSource.loadStops();

  Future<List<TransitLine>> getLines() => _dataSource.loadLines();

  Future<List<TransitAlert>> getAlerts() => _dataSource.loadAlerts();

  Future<List<VehiclePosition>> getVehiclePositions() =>
      _dataSource.loadVehicles();

  Future<List<TransitRouteOption>> getRouteOptions() =>
      _dataSource.loadRoutes();

  Future<List<Departure>> getDepartures() => _dataSource.loadDepartures();

  Future<List<TransitStop>> searchStops(String query) async {
    final stops = await getStops();
    if (query.isEmpty) return stops.take(8).toList();
    final lower = query.toLowerCase();
    return stops
        .where((stop) =>
            stop.name.toLowerCase().contains(lower) ||
            stop.wilaya.toLowerCase().contains(lower))
        .toList();
  }

  Future<List<TransitLine>> searchLines(String query) async {
    final lines = await getLines();
    final lower = query.toLowerCase();
    return lines
        .where((line) =>
            line.name.toLowerCase().contains(lower) ||
            line.code.toLowerCase().contains(lower))
        .toList();
  }

  Future<TransitStop?> getStopById(String stopId) async {
    final stops = await getStops();
    return stops.firstWhereOrNull((stop) => stop.id == stopId);
  }

  Future<TransitLine?> getLineById(String lineId) async {
    final lines = await getLines();
    return lines.firstWhereOrNull((line) => line.id == lineId);
  }
}
