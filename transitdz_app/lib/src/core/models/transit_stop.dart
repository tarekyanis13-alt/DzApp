import 'package:flutter/foundation.dart';

enum TransitMode { bus, tram, metro, rail, intercity, sharedTaxi }

@immutable
class TransitStop {
  const TransitStop({
    required this.id,
    required this.name,
    required this.wilaya,
    required this.latitude,
    required this.longitude,
    required this.modes,
    required this.lines,
    this.address,
    this.crowdingLevel = 0.5,
    this.amenities = const [],
  });

  final String id;
  final String name;
  final String wilaya;
  final double latitude;
  final double longitude;
  final List<TransitMode> modes;
  final List<String> lines;
  final String? address;
  final double crowdingLevel;
  final List<String> amenities;

  factory TransitStop.fromJson(Map<String, dynamic> json) {
    return TransitStop(
      id: json['id'] as String,
      name: json['name'] as String,
      wilaya: json['wilaya'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      modes: (json['modes'] as List<dynamic>)
          .map((mode) => TransitMode.values.firstWhere(
                (e) => describeEnum(e) == mode,
                orElse: () => TransitMode.bus,
              ))
          .toList(),
      lines: (json['lines'] as List<dynamic>).cast<String>(),
      address: json['address'] as String?,
      crowdingLevel: (json['crowdingLevel'] as num?)?.toDouble() ?? 0.5,
      amenities: (json['amenities'] as List<dynamic>?)?.cast<String>() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'wilaya': wilaya,
        'latitude': latitude,
        'longitude': longitude,
        'modes': modes.map(describeEnum).toList(),
        'lines': lines,
        'address': address,
        'crowdingLevel': crowdingLevel,
        'amenities': amenities,
      };
}
