import 'package:flutter/material.dart';
import 'habit.dart';
import 'tracking_service.dart';
import 'daily_check_button.dart';

class HabitTile extends StatelessWidget {
  final Habit habit;
  final TrackingService trackingService;
  final Future<void> Function() onDelete;
  final Future<void> Function() onCheck;

  const HabitTile({
    super.key,
    required this.habit,
    required this.trackingService,
    required this.onDelete,
    required this.onCheck,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    habit.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Supprimer',
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Supprimer'),
                        content: const Text('Supprimer cette habitude ?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Annuler')),
                          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Supprimer')),
                        ],
                      ),
                    );

                    if (confirmed == true) {
                      await onDelete();
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            DailyCheckButton(
              habit: habit,
              trackingService: trackingService,
              onChecked: onCheck,
            ),
          ],
        ),
      ),
    );
  }
}
