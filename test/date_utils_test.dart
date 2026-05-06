import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/features/habits/date_utils.dart' as habit_utils;

void main() {
  group('DateUtils Tests', () {
    test('todayUTC should return a string in YYYY-MM-DD format', () {
      final today = habit_utils.DateUtils.todayUTC();
      
      // Vérifie le format (ex: 2024-05-06)
      final regExp = RegExp(r'^\d{4}-\d{2}-\d{2}$');
      expect(regExp.hasMatch(today), isTrue);
    });

    test('formatReadable should return a localized date string', () {
      // Note: On teste avec une date fixe
      const date = '2024-05-06';
      final formatted = habit_utils.DateUtils.formatReadable(date);
      
      // En fr_FR, cela devrait contenir "mai" et "2024"
      expect(formatted.toLowerCase(), contains('mai'));
      expect(formatted, contains('2024'));
    });
  });
}
