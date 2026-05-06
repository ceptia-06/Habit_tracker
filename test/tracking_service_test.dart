import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/features/habits/habit_check.dart';

void main() {
  group('HabitCheck Model Tests', () {
    test('fromJson should correctly parse a Supabase JSON response', () {
      final json = {
        'id': 'check-123',
        'habit_id': 'habit-456',
        'user_id': 'user-789',
        'checked_date': '2024-05-06',
        'created_at': '2024-05-06T10:00:00Z',
      };

      final check = HabitCheck.fromJson(json);

      expect(check.id, 'check-123');
      expect(check.habitId, 'habit-456');
      expect(check.userId, 'user-789');
      expect(check.checkedDate, '2024-05-06');
      expect(check.createdAt.isUtc, isTrue);
      expect(check.createdAt.year, 2024);
    });

    test('toJson should return a correct map', () {
      final check = HabitCheck(
        id: '1',
        habitId: 'habit-1',
        userId: 'user-1',
        checkedDate: '2024-05-06',
        createdAt: DateTime.utc(2024, 5, 6),
      );

      final json = check.toJson();

      expect(json['id'], '1');
      expect(json['checked_date'], '2024-05-06');
      expect(json['created_at'], contains('2024-05-06'));
    });
  });
}
