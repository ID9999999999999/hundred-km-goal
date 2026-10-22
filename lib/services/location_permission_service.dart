import 'package:geolocator/geolocator.dart';

class LocationPermissionService {
  const LocationPermissionService._();

  static Future<String?> ensureReady() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return 'Геолокация выключена. Включите GPS перед тренировкой.';
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      return 'Доступ к геолокации не разрешён.';
    }

    if (permission == LocationPermission.deniedForever) {
      return 'Разрешите доступ к геолокации в настройках приложения.';
    }

    return null;
  }
}
