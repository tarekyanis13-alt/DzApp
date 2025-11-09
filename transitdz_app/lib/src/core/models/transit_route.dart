import 'package:flutter/foundation.dart';

import 'transit_line.dart';
import 'transit_stop.dart';

enum RouteOptimization { fastest, leastWalking, cheapest }

enum StepType { walk, ride, transfer }

@immutable
class TransitRouteOption {
  const TransitRouteOption({
    required this.id,
    required this.departureTime,
    required this.arrivalTime,
    required this.totalDurationMinutes,
    required this.totalWalkingMinutes,
    required this.steps,
    required this.optimization,
    required this.emissionsKg,
    required this.costDZD,
  });

  final String id;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final int totalDurationMinutes;
  final int totalWalkingMinutes;
  final List<TransitRouteStep> steps;
  final RouteOptimization optimization;
  final double emissionsKg;
  final double costDZD;

  int get transfers =>
      steps.where((step) => step.type == StepType.transfer).length;

  Map<String, dynamic> toJson() => {
        'id': id,
        'departureTime': departureTime.toIso8601String(),
        'arrivalTime': arrivalTime.toIso8601String(),
        'totalDurationMinutes': totalDurationMinutes,
        'totalWalkingMinutes': totalWalkingMinutes,
        'steps': steps.map((s) => s.toJson()).toList(),
        'optimization': describeEnum(optimization),
        'emissionsKg': emissionsKg,
        'costDZD': costDZD,
      };
}

@immutable
class TransitRouteStep {
  const TransitRouteStep({
    required this.type,
    required this.description,
    required this.durationMinutes,
    this.distanceMeters,
    this.line,
    this.from,
    this.to,
    this.polyline,
  });

  final StepType type;
  final String description;
  final int durationMinutes;
  final double? distanceMeters;
  final TransitLine? line;
  final TransitStop? from;
  final TransitStop? to;
  final List<List<double>>? polyline;

  Map<String, dynamic> toJson() => {
        'type': describeEnum(type),
        'description': description,
        'durationMinutes': durationMinutes,
        'distanceMeters': distanceMeters,
        'line': line?.toJson(),
        'from': from?.toJson(),
        'to': to?.toJson(),
        'polyline': polyline,
      };
}
