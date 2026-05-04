import 'package:supabase_flutter/supabase_flutter.dart';
import '../auth/data/auth_service.dart';
import 'habit.dart';

class HabitService {
  final SupabaseClient _client = Supabase.instance.client;
  final AuthService _authService = AuthService();

  String get _userId {
    final userId = _authService.currentUserId;
    if (userId == null) {
      throw StateError('Utilisateur non connecté');
    }
    return userId;
  }

  Stream<List<Habit>> watchHabits() {
    return _client
        .from('habits')
        .stream(primaryKey: ['id'])
        .eq('user_id', _userId)
        .order('created_at', ascending: false)
        .map((rows) {
      return rows
          .map((row) => Habit.fromJson(row))
          .toList();
    });
  }

  Future<Habit> createHabit(String name) async {
    final response = await _client.from('habits').insert({
      'user_id': _userId,
      'name': name.trim(),
    }).select().single();
    return Habit.fromJson(response);
  }

  Future<void> deleteHabit(String id) async {
    await _client.from('habits').delete().eq('id', id).eq('user_id', _userId);
  }
}
