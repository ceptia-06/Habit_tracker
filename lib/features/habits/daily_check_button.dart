import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers.dart';
import 'habit.dart';

class DailyCheckButton extends ConsumerStatefulWidget {
  final Habit habit;
  final Future<void> Function() onChecked;

  const DailyCheckButton({
    super.key,
    required this.habit,
    required this.onChecked,
  });

  @override
  ConsumerState<DailyCheckButton> createState() => _DailyCheckButtonState();
}

class _DailyCheckButtonState extends ConsumerState<DailyCheckButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final checksAsync = ref.watch(checksProvider);

    return checksAsync.when(
      loading: () => const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF6366F1)),
      ),
      error: (_, __) => const Icon(Icons.error_outline, color: Colors.red),
      data: (checks) {
        final isChecked = checks.any((c) => c.habitId == widget.habit.id);

        return ScaleTransition(
          scale: _scaleAnimation,
          child: GestureDetector(
            onTap: isChecked
                ? null
                : () async {
                    _controller.forward(from: 0);
                    await widget.onChecked();
                  },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isChecked
                    ? const LinearGradient(
                        colors: [Color(0xFF10B981), Color(0xFF059669)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : LinearGradient(
                        colors: [const Color(0xFFF1F5F9), const Color(0xFFE2E8F0)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                boxShadow: isChecked
                    ? [
                        BoxShadow(
                          color: const Color(0xFF10B981).withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : [],
              ),
              child: Icon(
                isChecked ? Icons.check_rounded : Icons.add_rounded,
                color: isChecked ? Colors.white : const Color(0xFF94A3B8),
                size: 24,
              ),
            ),
          ),
        );
      },
    );
  }
}
