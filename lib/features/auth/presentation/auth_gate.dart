import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/auth_service.dart';
import 'login_screen.dart';
import '../../habits/habit_list_screen.dart';

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
          return const HabitListScreen();
        }

        return const LoginScreen();
      },
    );
  }
}
