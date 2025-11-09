import 'package:flutter/foundation.dart';

enum VehicleStatus { onTime, delayed, ahead }

@immutable
class VehiclePosition {
  const VehiclePosition({
    required this.id,
    required this.lineId,
    required this.mode,
    required this.latitude,
    required this.longitude,
    required this.bearing,
    required this.lastUpdated,
    this.status = VehicleStatus.onTime,
    this.speedKmh,
  });

  final String id;
  final String lineId;
  final String mode;
  final double latitude;
  final double longitude;
  final double bearing;
  final DateTime lastUpdated;
  final VehicleStatus status;
  final double? speedKmh;

  VehiclePosition copyWith({
    double? latitude,
    double? longitude,
    double? bearing,
    DateTime? lastUpdated,
    VehicleStatus? status,
    double? speedKmh,
  }) {
    return VehiclePosition(
      id: id,
      lineId: lineId,
      mode: mode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      bearing: bearing ?? this.bearing,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      status: status ?? this.status,
      speedKmh: speedKmh ?? this.speedKmh,
    );
  }
}
