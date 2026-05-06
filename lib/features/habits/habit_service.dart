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

  Stream<List<Habit>> watchHabits() async* {
    while (true) {
      try {
        final stream = _client
            .from('habits')
            .stream(primaryKey: ['id'])
            .eq('user_id', _userId)
            .order('created_at', ascending: false)
            .map((rows) {
          final habits = rows.map((row) => Habit.fromJson(row)).toList();
          // Tri local supplémentaire pour garantir l'ordre
          habits.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return habits;
        });
        
        yield* stream;
      } catch (e) {
        // Attendre avant de réessayer en cas d'erreur de connexion
        await Future.delayed(const Duration(seconds: 2));
      }
    }
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
