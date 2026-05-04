import 'package:flutter/material.dart';
import 'tracking_service.dart';
import 'habit.dart';
import 'habit_check.dart';
import 'date_utils.dart' as habit_date_utils;

class HistoryScreen extends StatelessWidget {
  final List<Habit> habits;
  final TrackingService trackingService;

  const HistoryScreen({super.key, required this.habits, required this.trackingService});

  @override
  Widget build(BuildContext context) {
    final habitMap = {for (final habit in habits) habit.id: habit};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique'),
      ),
      body: StreamBuilder<List<HabitCheck>>(
        stream: trackingService.watchAllChecks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final checks = snapshot.data ?? <HabitCheck>[];
          if (checks.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Aucune validation enregistrée pour le moment. Valide une habitude pour voir l\'historique.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            );
          }

          final orderedChecks = List<HabitCheck>.from(checks)
            ..sort((a, b) => b.checkedDate.compareTo(a.checkedDate));

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: orderedChecks.length,
            separatorBuilder: (_, __) => const Divider(height: 0),
            itemBuilder: (context, index) {
              final check = orderedChecks[index];
              final habitName = habitMap[check.habitId]?.name ?? 'Habitude supprimée';

              return ListTile(
                title: Text(habitName, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(habit_date_utils.DateUtils.formatReadable(check.checkedDate)),
                leading: const Icon(Icons.history_outlined),
              );
            },
          );
        },
      ),
    );
  }
}
