import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/departure.dart';
import '../models/transit_alert.dart';
import '../models/transit_line.dart';
import '../models/transit_route.dart';
import '../models/transit_stop.dart';
import '../models/vehicle_position.dart';
import '../utils/datetime_utils.dart';

class MockTransitDataSource {
  List<TransitStop>? _stops;
  List<TransitLine>? _lines;
  List<TransitRouteOption>? _routes;
  List<TransitAlert>? _alerts;
  List<VehiclePosition>? _vehicles;
  List<Departure>? _departures;

  Future<List<TransitStop>> loadStops() async {
    if (_stops != null) return _stops!;
    final jsonString = await rootBundle.loadString('assets/data/stops.json');
    final data = json.decode(jsonString) as List<dynamic>;
    _stops = data.map((e) => TransitStop.fromJson(e as Map<String, dynamic>)).toList();
    return _stops!;
  }

  Future<List<TransitLine>> loadLines() async {
    if (_lines != null) return _lines!;
    final jsonString = await rootBundle.loadString('assets/data/lines.json');
    final data = json.decode(jsonString) as List<dynamic>;
    _lines = data.map((e) => TransitLine.fromJson(e as Map<String, dynamic>)).toList();
    return _lines!;
  }

  Future<List<TransitAlert>> loadAlerts() async {
    if (_alerts != null) return _alerts!;
    final jsonString = await rootBundle.loadString('assets/data/alerts.json');
    final data = json.decode(jsonString) as List<dynamic>;
    final lines = await loadLines();
    final lineMap = {for (final line in lines) line.id: line};
    _alerts = data.map((dynamic entry) {
      final map = entry as Map<String, dynamic>;
      return TransitAlert(
        id: map['id'] as String,
        title: map['title'] as String,
        message: map['message'] as String,
        severity: AlertSeverity.values.firstWhere(
          (e) => describeEnum(e) == map['severity'],
          orElse: () => AlertSeverity.info,
        ),
        scope: AlertScope.values.firstWhere(
          (e) => describeEnum(e) == map['scope'],
          orElse: () => AlertScope.network,
        ),
        status: AlertStatus.values.firstWhere(
          (e) => describeEnum(e) == map['status'],
          orElse: () => AlertStatus.active,
        ),
        line: map['lineId'] != null ? lineMap[map['lineId']] : null,
        stopId: map['stopId'] as String?,
        validFrom: map['validFrom'] != null
            ? DateTime.tryParse(map['validFrom'] as String)
            : null,
        validUntil: map['validUntil'] != null
            ? DateTime.tryParse(map['validUntil'] as String)
            : null,
      );
    }).toList();
    return _alerts!;
  }

  Future<List<TransitRouteOption>> loadRoutes() async {
    if (_routes != null) return _routes!;
    final jsonString = await rootBundle.loadString('assets/data/routes.json');
    final data = json.decode(jsonString) as List<dynamic>;
    final lines = await loadLines();
    final stops = await loadStops();
    final lineMap = {for (final line in lines) line.id: line};
    final stopMap = {for (final stop in stops) stop.id: stop};
    _routes = data.map((dynamic entry) {
      final map = entry as Map<String, dynamic>;
      final steps = (map['steps'] as List<dynamic>).map((stepData) {
        final stepMap = stepData as Map<String, dynamic>;
        return TransitRouteStep(
          type: StepType.values.firstWhere(
            (e) => describeEnum(e) == stepMap['type'],
            orElse: () => StepType.walk,
          ),
          description: stepMap['description'] as String,
          durationMinutes: (stepMap['durationMinutes'] as num).toInt(),
          distanceMeters: (stepMap['distanceMeters'] as num?)?.toDouble(),
          line: stepMap['lineId'] != null ? lineMap[stepMap['lineId']] : null,
          from:
              stepMap['fromStop'] != null ? stopMap[stepMap['fromStop']] : null,
          to: stepMap['toStop'] != null ? stopMap[stepMap['toStop']] : null,
          polyline: (stepMap['polyline'] as List<dynamic>?)
              ?.map((e) => (e as List<dynamic>).map((c) => (c as num).toDouble()).toList())
              .toList(),
        );
      }).toList();
      return TransitRouteOption(
        id: map['id'] as String,
        departureTime: DateTime.parse(map['departureTime'] as String),
        arrivalTime: DateTime.parse(map['arrivalTime'] as String),
        totalDurationMinutes: (map['totalDurationMinutes'] as num).toInt(),
        totalWalkingMinutes: (map['totalWalkingMinutes'] as num).toInt(),
        steps: steps,
        optimization: RouteOptimization.values.firstWhere(
          (e) => describeEnum(e) == map['optimization'],
          orElse: () => RouteOptimization.fastest,
        ),
        emissionsKg: (map['emissionsKg'] as num).toDouble(),
        costDZD: (map['costDZD'] as num).toDouble(),
      );
    }).toList();
    return _routes!;
  }

  Future<List<VehiclePosition>> loadVehicles() async {
    if (_vehicles != null) return _vehicles!;
    final jsonString = await rootBundle.loadString('assets/data/vehicles.json');
    final data = json.decode(jsonString) as List<dynamic>;
    _vehicles = data.map((dynamic entry) {
      final map = entry as Map<String, dynamic>;
      return VehiclePosition(
        id: map['id'] as String,
        lineId: map['lineId'] as String,
        mode: map['mode'] as String,
        latitude: (map['latitude'] as num).toDouble(),
        longitude: (map['longitude'] as num).toDouble(),
        bearing: (map['bearing'] as num).toDouble(),
        lastUpdated: parseZonedDateTime(map['updatedAt'] as String),
        status: VehicleStatus.values.firstWhere(
          (e) => describeEnum(e) == map['status'],
          orElse: () => VehicleStatus.onTime,
        ),
        speedKmh: (map['speedKmh'] as num?)?.toDouble(),
      );
    }).toList();
    return _vehicles!;
  }

  Future<List<Departure>> loadDepartures() async {
    if (_departures != null) return _departures!;
    final jsonString =
        await rootBundle.loadString('assets/data/departures.json');
    final data = json.decode(jsonString) as List<dynamic>;
    final lines = await loadLines();
    final lineMap = {for (final line in lines) line.id: line};
    _departures = data.map((dynamic entry) {
      final map = entry as Map<String, dynamic>;
      return Departure(
        stopId: map['stopId'] as String,
        line: lineMap[map['lineId']]!,
        destination: map['destination'] as String,
        arrivalMinutes: (map['arrivalMinutes'] as num).toInt(),
        status: DepartureStatus.values.firstWhere(
          (e) => describeEnum(e) == map['status'],
          orElse: () => DepartureStatus.onTime,
        ),
        platform: map['platform'] as String?,
      );
    }).toList();
    return _departures!;
  }
}
