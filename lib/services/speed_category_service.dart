class SpeedCategoryService {
  static const double slowRunMinKmh = 6.0;
  static const double slowRunMaxKmh = 8.5;

  const SpeedCategoryService._();

  static String label(double speedKmh) {
    if (speedKmh <= 0) return 'Недостаточно движения';
    if (speedKmh < slowRunMinKmh) return 'Ходьба';
    if (speedKmh <= slowRunMaxKmh) return 'Лёгкий бег';
    if (speedKmh <= 12.5) return 'Обычный бег';
    return 'Быстрый бег';
  }

  static String passportNote(double speedKmh) => label(speedKmh);

  static String get slowRunBandText => 'Ориентир лёгкого бега: 6,0–8,5 км/ч';
}
