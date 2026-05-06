import 'package:supabase_flutter/supabase_flutter.dart';
import '../auth/data/auth_service.dart';
import 'date_utils.dart';
import 'habit_check.dart';

class TrackingService {
  final SupabaseClient _client = Supabase.instance.client;
  final AuthService _authService = AuthService();

  String get _userId {
    final userId = _authService.currentUserId;
    if (userId == null) {
      throw StateError('Utilisateur non connecté');
    }
    return userId;
  }

  Future<HabitCheck> checkHabit(String habitId) async {
    final today = DateUtils.todayUTC();
    final existing = await _client
        .from('habit_checks')
        .select('id')
        .eq('user_id', _userId)
        .eq('habit_id', habitId)
        .eq('checked_date', today)
        .limit(1);

    if ((existing as List).isNotEmpty) {
      throw StateError('Cette habitude est déjà cochée aujourd\'hui.');
    }

    final response = await _client.from('habit_checks').insert({
      'habit_id': habitId,
      'user_id': _userId,
      'checked_date': today,
    }).select().single();
    return HabitCheck.fromJson(response);
  }

  Stream<List<HabitCheck>> watchChecksForToday() async* {
    final today = DateUtils.todayUTC();
    while (true) {
      try {
        final stream = _client
            .from('habit_checks')
            .stream(primaryKey: ['id'])
            .eq('user_id', _userId)
            .map((rows) {
          return rows
              .where((row) => row['checked_date'] == today)
              .map((row) => HabitCheck.fromJson(row))
              .toList();
        });
        yield* stream;
      } catch (e) {
        await Future.delayed(const Duration(seconds: 2));
      }
    }
  }

  Stream<List<HabitCheck>> watchAllChecks() async* {
    while (true) {
      try {
        final stream = _client
            .from('habit_checks')
            .stream(primaryKey: ['id'])
            .eq('user_id', _userId)
            .order('checked_date', ascending: false)
            .map((rows) {
          final checks = rows.map((row) => HabitCheck.fromJson(row)).toList();
          // Tri par date décroissante, puis par ID décroissant pour les checks du même jour
          checks.sort((a, b) {
            final dateCmp = b.checkedDate.compareTo(a.checkedDate);
            if (dateCmp != 0) return dateCmp;
            return b.id.compareTo(a.id); 
          });
          return checks;
        });
        yield* stream;
      } catch (e) {
        await Future.delayed(const Duration(seconds: 2));
      }
    }
  }
}
