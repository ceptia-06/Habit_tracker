import 'package:flutter/material.dart';
import 'tracking_service.dart';
import 'habit.dart';
import 'habit_check.dart';

class DailyCheckButton extends StatelessWidget {
  final Habit habit;
  final TrackingService trackingService;
  final Future<void> Function() onChecked;

  const DailyCheckButton({
    super.key,
    required this.habit,
    required this.trackingService,
    required this.onChecked,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<HabitCheck>>(
      stream: trackingService.watchChecksForToday(),
      builder: (context, snapshot) {
        final isChecked = snapshot.hasData
            ? snapshot.data!.any((check) => check.habitId == habit.id)
            : false;

        return FilledButton.icon(
          onPressed: isChecked ? null : () async {
            await onChecked();
          },
          icon: Icon(isChecked ? Icons.check_circle_outline : Icons.calendar_today_outlined),
          label: Text(isChecked ? 'Coché aujourd\'hui' : 'Valider'),
          style: FilledButton.styleFrom(
            backgroundColor: isChecked ? Colors.green.shade600 : null,
          ),
        );
      },
    );
  }
}
