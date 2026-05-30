class GeoPoint {
  const GeoPoint({
    required this.latitude,
    required this.longitude,
    required this.recordedAt,
    this.accuracyMeters,
    this.speedMetersPerSecond,
  });

  final double latitude;
  final double longitude;
  final DateTime recordedAt;
  final double? accuracyMeters;
  final double? speedMetersPerSecond;

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'recordedAt': recordedAt.toIso8601String(),
      'accuracyMeters': accuracyMeters,
      'speedMetersPerSecond': speedMetersPerSecond,
    };
  }

  factory GeoPoint.fromJson(Map<String, dynamic> json) {
    return GeoPoint(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      recordedAt: DateTime.parse(json['recordedAt'] as String),
      accuracyMeters: (json['accuracyMeters'] as num?)?.toDouble(),
      speedMetersPerSecond: (json['speedMetersPerSecond'] as num?)?.toDouble(),
    );
  }
}
