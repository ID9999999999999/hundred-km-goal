class SpeedCategoryService {
  static const double slowRunMinKmh = 6.0;
  static const double slowRunMaxKmh = 8.5;

  const SpeedCategoryService._();

  static String label(double speedKmh) {
    if (speedKmh <= 0) {
      return 'Not enough movement';
    }
    if (speedKmh < slowRunMinKmh) {
      return 'Walking pace';
    }
    if (speedKmh <= slowRunMaxKmh) {
      return 'Slow easy run';
    }
    if (speedKmh <= 12.5) {
      return 'Normal running pace';
    }
    return 'Fast running pace';
  }

  static String passportNote(double speedKmh) {
    if (speedKmh <= 0) {
      return 'Start a session to receive the first passport stamp.';
    }
    if (speedKmh < slowRunMinKmh) {
      return 'Recorded calmly below the slow-running band.';
    }
    if (speedKmh <= slowRunMaxKmh) {
      return 'Inside the normal slow-running band.';
    }
    if (speedKmh <= 12.5) {
      return 'Above slow jog, still inside ordinary running rhythm.';
    }
    return 'Fast session compared with the slow-running reference.';
  }

  static String get slowRunBandText => 'Slow running reference: 6.0–8.5 km/h';
}
