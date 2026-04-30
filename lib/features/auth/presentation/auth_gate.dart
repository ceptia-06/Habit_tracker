import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/auth_service.dart';
import 'login_screen.dart';
// Dev B créera ce fichier — import conditionnel pour éviter les erreurs de build
// import '../../habits/presentation/habit_list_screen.dart';

/// Widget racine de l'application.
/// Écoute le stream [onAuthStateChange] de Supabase et redirige
/// automatiquement vers LoginScreen ou HomeScreen selon la session.
/// 
/// Tous les appareils se synchronisent via ce widget — si un utilisateur
/// se déconnecte sur un appareil, tous les autres reviennent à LoginScreen.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder<AuthState>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // En attente de la première valeur du stream
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final session = snapshot.data?.session;

        if (session != null) {
          // ✅ Connecté → remplacer par HomeScreen quand Dev B aura créé le fichier
          // return const HabitListScreen();
          return _PlaceholderHome(userId: session.user.id);
        }

        return const LoginScreen();
      },
    );
  }
}

/// Écran temporaire en attendant que Dev B crée HabitListScreen.
/// À supprimer et remplacer par HabitListScreen une fois Dev B prêt.
class _PlaceholderHome extends StatelessWidget {
  final String userId;
  const _PlaceholderHome({required this.userId});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Se déconnecter',
            onPressed: () async {
              await authService.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
            const SizedBox(height: 16),
            const Text(
              'Authentification réussie !',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'User ID : $userId',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            const Text(
              '⏳ En attente de HabitListScreen (Dev B)',
              style: TextStyle(color: Colors.orange),
            ),
          ],
        ),
      ),
    );
  }
}
