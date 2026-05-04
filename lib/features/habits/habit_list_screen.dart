import 'package:flutter/material.dart';
import '../auth/data/auth_service.dart';
import 'habit.dart';
import 'habit_service.dart';
import 'tracking_service.dart';
import 'add_habit_dialog.dart';
import 'habit_tile.dart';
import 'history_screen.dart';

class HabitListScreen extends StatefulWidget {
  const HabitListScreen({super.key});

  @override
  State<HabitListScreen> createState() => _HabitListScreenState();
}

class _HabitListScreenState extends State<HabitListScreen> {
  final _habitService = HabitService();
  final _trackingService = TrackingService();
  final _authService = AuthService();
  bool _isWorking = false;

  Future<void> _showError(String message) async {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  Future<void> _addHabit() async {
    final name = await showDialog<String>(
      context: context,
      builder: (_) => const AddHabitDialog(),
    );

    if (name == null || name.isEmpty) {
      return;
    }

    setState(() => _isWorking = true);
    try {
      await _habitService.createHabit(name);
    } catch (error) {
      _showError('Impossible de créer l\'habitude.');
    } finally {
      if (mounted) setState(() => _isWorking = false);
    }
  }

  Future<void> _deleteHabit(String habitId) async {
    setState(() => _isWorking = true);
    try {
      await _habitService.deleteHabit(habitId);
    } catch (_) {
      _showError('Impossible de supprimer l\'habitude.');
    } finally {
      if (mounted) setState(() => _isWorking = false);
    }
  }

  Future<void> _checkHabit(String habitId) async {
    setState(() => _isWorking = true);
    try {
      await _trackingService.checkHabit(habitId);
    } catch (error) {
      _showError(error.toString());
    } finally {
      if (mounted) setState(() => _isWorking = false);
    }
  }

  Future<void> _signOut() async {
    await _authService.signOut();
  }

  void _openHistory(List<Habit> habits) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => HistoryScreen(
          habits: habits,
          trackingService: _trackingService,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes habitudes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Historique',
            onPressed: () async {
              final habits = await _habitService.watchHabits().first;
              _openHistory(habits);
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Se déconnecter',
            onPressed: _signOut,
          ),
        ],
      ),
      body: StreamBuilder<List<Habit>>(
        stream: _habitService.watchHabits(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final habits = snapshot.data ?? <Habit>[];
          if (habits.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.track_changes_outlined, size: 60, color: Colors.grey),
                    SizedBox(height: 18),
                    Text(
                      'Aucune habitude pour l\'instant. Ajoute-en une pour commencer ton suivi quotidien.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await _habitService.watchHabits().first;
            },
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 88, top: 12),
              itemCount: habits.length,
              itemBuilder: (context, index) {
                final habit = habits[index];
                return HabitTile(
                  habit: habit,
                  trackingService: _trackingService,
                  onDelete: () => _deleteHabit(habit.id),
                  onCheck: () => _checkHabit(habit.id),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isWorking ? null : _addHabit,
        icon: const Icon(Icons.add),
        label: const Text('Nouvelle habitude'),
      ),
    );
  }
}
