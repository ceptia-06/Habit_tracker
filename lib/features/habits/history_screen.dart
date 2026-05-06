import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers.dart';
import 'habit_check.dart';
import 'date_utils.dart' as habit_date_utils;

class HistoryScreen extends ConsumerWidget {
  final String? habitId;

  const HistoryScreen({super.key, this.habitId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(habitsProvider);
    final trackingService = ref.read(trackingServiceProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: habitsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erreur : $err')),
        data: (habits) {
          final habitMap = {for (final habit in habits) habit.id: habit};

          return StreamBuilder<List<HabitCheck>>(
            stream: trackingService.watchAllChecks(),
            builder: (context, snapshot) {
              final checks = (snapshot.data ?? <HabitCheck>[])
                  .where((c) => habitId == null || habitId == 'all' || c.habitId == habitId)
                  .toList();

              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 120.0,
                    pinned: true,
                    elevation: 0,
                    backgroundColor: const Color(0xFF1E293B),
                    flexibleSpace: const FlexibleSpaceBar(
                      title: Text(
                        'Historique',
                        style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white, fontSize: 20),
                      ),
                      centerTitle: true,
                    ),
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  if (checks.isEmpty)
                    SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.history_toggle_off_rounded, size: 80, color: Colors.grey.shade300),
                            const SizedBox(height: 16),
                            const Text(
                              'Aucune activité enregistrée',
                              style: TextStyle(color: Color(0xFF64748B), fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.all(20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final check = checks[index];
                            final habitName = habitMap[check.habitId]?.name ?? 'Habitude supprimée';
                            final dateStr = habit_date_utils.DateUtils.formatReadable(check.checkedDate);

                            return IntrinsicHeight(
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        width: 16,
                                        height: 16,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF6366F1),
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white, width: 3),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                                              blurRadius: 10,
                                            )
                                          ],
                                        ),
                                      ),
                                      if (index != checks.length - 1)
                                        Expanded(
                                          child: Container(
                                            width: 2,
                                            color: const Color(0xFFE2E8F0),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 24),
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.03),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          )
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            habitName,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1E293B),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              Icon(Icons.access_time_rounded, size: 14, color: Colors.grey.shade400),
                                              const SizedBox(width: 6),
                                              Text(
                                                dateStr,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey.shade500,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          childCount: checks.length,
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
