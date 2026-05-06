import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../features/auth/data/auth_service.dart';
import '../features/habits/habit_service.dart';
import '../features/habits/tracking_service.dart';
import '../features/habits/habit.dart';
import '../features/habits/habit_check.dart';

/// Provider pour le service d'authentification.
final authServiceProvider = Provider((ref) => AuthService());

/// Provider pour le service des habitudes.
final habitServiceProvider = Provider((ref) => HabitService());

/// Provider pour le service de suivi.
final trackingServiceProvider = Provider((ref) => TrackingService());

/// Provider exposant le flux d'état d'authentification.
final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

/// Provider exposant le flux des habitudes de l'utilisateur.
final habitsProvider = StreamProvider<List<Habit>>((ref) {
  return ref.watch(habitServiceProvider).watchHabits();
});

/// Provider exposant le flux des validations du jour.
final checksProvider = StreamProvider<List<HabitCheck>>((ref) {
  return ref.watch(trackingServiceProvider).watchChecksForToday();
});
