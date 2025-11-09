import 'package:flutter/foundation.dart';

import 'transit_line.dart';

enum AlertSeverity { info, warning, severe }

enum AlertScope { network, line, stop }

enum AlertStatus { active, resolved, upcoming }

@immutable
class TransitAlert {
  const TransitAlert({
    required this.id,
    required this.title,
    required this.message,
    required this.severity,
    required this.scope,
    required this.status,
    this.line,
    this.stopId,
    this.validFrom,
    this.validUntil,
  });

  final String id;
  final String title;
  final String message;
  final AlertSeverity severity;
  final AlertScope scope;
  final AlertStatus status;
  final TransitLine? line;
  final String? stopId;
  final DateTime? validFrom;
  final DateTime? validUntil;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'message': message,
        'severity': describeEnum(severity),
        'scope': describeEnum(scope),
        'status': describeEnum(status),
        'line': line?.toJson(),
        'stopId': stopId,
        'validFrom': validFrom?.toIso8601String(),
        'validUntil': validUntil?.toIso8601String(),
      };
}
