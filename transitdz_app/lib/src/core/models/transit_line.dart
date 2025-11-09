import 'package:flutter/foundation.dart';

import 'transit_stop.dart';

enum TransitLineCategory { urban, intercity, express }

enum FarePolicy { flat, distance, zone }

@immutable
class TransitLine {
  const TransitLine({
    required this.id,
    required this.name,
    required this.code,
    required this.mode,
    required this.color,
    required this.textColor,
    required this.operatingHours,
    required this.frequencyMinutes,
    required this.stops,
    this.category = TransitLineCategory.urban,
    this.farePolicy = FarePolicy.flat,
    this.description,
  });

  final String id;
  final String name;
  final String code;
  final TransitMode mode;
  final String color;
  final String textColor;
  final String operatingHours;
  final Map<String, int> frequencyMinutes; // {peak: 5, offPeak: 12}
  final List<String> stops;
  final TransitLineCategory category;
  final FarePolicy farePolicy;
  final String? description;

  factory TransitLine.fromJson(Map<String, dynamic> json) {
    return TransitLine(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      mode: TransitMode.values.firstWhere(
        (e) => describeEnum(e) == json['mode'],
        orElse: () => TransitMode.bus,
      ),
      color: json['color'] as String? ?? '#6B3EE6',
      textColor: json['textColor'] as String? ?? '#FFFFFF',
      operatingHours: json['operatingHours'] as String? ?? '05:00 - 23:30',
      frequencyMinutes:
          (json['frequencyMinutes'] as Map<String, dynamic>).map((key, value) =>
              MapEntry(key, (value as num).toInt())),
      stops: (json['stops'] as List<dynamic>).cast<String>(),
      category: TransitLineCategory.values.firstWhere(
        (e) => describeEnum(e) == json['category'],
        orElse: () => TransitLineCategory.urban,
      ),
      farePolicy: FarePolicy.values.firstWhere(
        (e) => describeEnum(e) == json['farePolicy'],
        orElse: () => FarePolicy.flat,
      ),
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'code': code,
        'mode': describeEnum(mode),
        'color': color,
        'textColor': textColor,
        'operatingHours': operatingHours,
        'frequencyMinutes': frequencyMinutes,
        'stops': stops,
        'category': describeEnum(category),
        'farePolicy': describeEnum(farePolicy),
        'description': description,
      };
}
