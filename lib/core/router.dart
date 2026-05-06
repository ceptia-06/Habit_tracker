import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/habits/habit_list_screen.dart';
import '../features/habits/history_screen.dart';
import 'providers.dart';

/// Configuration de GoRouter avec gestion de la redirection d'authentification.
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/home',
    // Redirection automatique selon l'état d'authentification
    redirect: (context, state) {
      final loggedIn = authState.value?.user != null;
      final loggingIn = state.matchedLocation == '/login';

      if (!loggedIn && !loggingIn) return '/login';
      if (loggedIn && loggingIn) return '/home';

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HabitListScreen(),
      ),
      GoRoute(
        path: '/history/:habitId',
        builder: (context, state) {
          final habitId = state.pathParameters['habitId'];
          // Note : HistoryScreen sera mis à jour pour utiliser les providers en Phase 2
          return const HistoryScreen();
        },
      ),
    ],
  );
});
