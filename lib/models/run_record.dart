import 'geo_point.dart';

class RunRecord {
  const RunRecord({
    required this.id,
    required this.startedAt,
    required this.finishedAt,
    required this.distanceKm,
    required this.durationSeconds,
    required this.averageSpeedKmh,
    required this.routePoints,
    this.isDemo = false,
    this.stadiumLaps,
  });

  final String id;
  final DateTime startedAt;
  final DateTime finishedAt;
  final double distanceKm;
  final int durationSeconds;
  final double averageSpeedKmh;
  final List<GeoPoint> routePoints;
  final bool isDemo;
  final int? stadiumLaps;

  bool get hasRoute => routePoints.length >= 2;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isDemo': isDemo,
      'stadiumLaps': stadiumLaps,
      'startedAt': startedAt.toIso8601String(),
      'finishedAt': finishedAt.toIso8601String(),
      'distanceKm': distanceKm,
      'durationSeconds': durationSeconds,
      'averageSpeedKmh': averageSpeedKmh,
      'routePoints': routePoints.map((point) => point.toJson()).toList(),
    };
  }

  factory RunRecord.fromJson(Map<String, dynamic> json) {
    return RunRecord(
      id: json['id'] as String,
      isDemo: json['isDemo'] as bool? ?? false,
      stadiumLaps: json['stadiumLaps'] as int?,
      startedAt: DateTime.parse(json['startedAt'] as String),
      finishedAt: DateTime.parse(json['finishedAt'] as String),
      distanceKm: (json['distanceKm'] as num).toDouble(),
      durationSeconds: (json['durationSeconds'] as num).toInt(),
      averageSpeedKmh: (json['averageSpeedKmh'] as num).toDouble(),
      routePoints: (json['routePoints'] as List<dynamic>)
          .map((item) => GeoPoint.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
