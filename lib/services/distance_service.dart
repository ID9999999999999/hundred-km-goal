import 'dart:math';

import '../models/geo_point.dart';

class DistanceService {
  static const double earthRadiusMeters = 6371000;

  const DistanceService._();

  static double haversineMeters(GeoPoint a, GeoPoint b) {
    final lat1 = _degreesToRadians(a.latitude);
    final lat2 = _degreesToRadians(b.latitude);
    final deltaLat = _degreesToRadians(b.latitude - a.latitude);
    final deltaLon = _degreesToRadians(b.longitude - a.longitude);

    final h = sin(deltaLat / 2) * sin(deltaLat / 2) +
        cos(lat1) * cos(lat2) * sin(deltaLon / 2) * sin(deltaLon / 2);
    final c = 2 * atan2(sqrt(h), sqrt(1 - h));
    return earthRadiusMeters * c;
  }

  static double totalDistanceKm(List<GeoPoint> points) {
    if (points.length < 2) {
      return 0;
    }

    double meters = 0;
    for (var i = 1; i < points.length; i++) {
      meters += haversineMeters(points[i - 1], points[i]);
    }
    return meters / 1000;
  }

  static double averageSpeedKmh({
    required double distanceKm,
    required int durationSeconds,
  }) {
    if (durationSeconds <= 0) {
      return 0;
    }
    return distanceKm / (durationSeconds / 3600);
  }

  static double segmentSpeedKmh(GeoPoint a, GeoPoint b) {
    final seconds = b.recordedAt.difference(a.recordedAt).inSeconds;
    if (seconds <= 0) {
      return 0;
    }
    final km = haversineMeters(a, b) / 1000;
    return km / (seconds / 3600);
  }

  static double _degreesToRadians(double degrees) => degrees * pi / 180;
}
