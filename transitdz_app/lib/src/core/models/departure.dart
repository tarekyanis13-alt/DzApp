import 'package:flutter/foundation.dart';

import 'transit_line.dart';

enum DepartureStatus { onTime, delayed, cancelled }

@immutable
class Departure {
  const Departure({
    required this.stopId,
    required this.line,
    required this.destination,
    required this.arrivalMinutes,
    required this.status,
    this.platform,
  });

  final String stopId;
  final TransitLine line;
  final String destination;
  final int arrivalMinutes;
  final DepartureStatus status;
  final String? platform;
}
