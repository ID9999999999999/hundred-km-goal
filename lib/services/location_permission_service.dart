import 'package:geolocator/geolocator.dart';

class LocationPermissionService {
  const LocationPermissionService._();

  static Future<String?> ensureReady() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return 'Location service is disabled. Enable GPS before starting a session.';
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      return 'Location permission was denied.';
    }

    if (permission == LocationPermission.deniedForever) {
      return 'Location permission is permanently denied. Open app settings and enable it manually.';
    }

    return null;
  }
}
