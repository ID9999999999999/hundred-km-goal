import 'package:flutter_test/flutter_test.dart';
import 'package:hundred_km_goal/services/speed_category_service.dart';

void main() {
  test('classifies normal slow running band', () {
    expect(SpeedCategoryService.label(6.0), 'Лёгкий бег');
    expect(SpeedCategoryService.label(7.4), 'Лёгкий бег');
    expect(SpeedCategoryService.label(8.5), 'Лёгкий бег');
  });

  test('classifies walking pace below slow running band', () {
    expect(SpeedCategoryService.label(5.2), 'Ходьба');
  });
}
