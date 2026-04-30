import 'package:supabase_flutter/supabase_flutter.dart';

/// Service centralisé pour toutes les opérations d'authentification.
/// Utilisé par LoginScreen, RegisterScreen et AuthGate.
class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  // ─── Getters utiles pour les autres devs ───────────────────────────────────

  /// Retourne l'utilisateur connecté ou null.
  User? get currentUser => _client.auth.currentUser;

  /// Retourne l'uid de l'utilisateur connecté ou null.
  String? get currentUserId => _client.auth.currentUser?.id;

  /// Stream d'état d'auth — écouté par AuthGate.
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  // ─── Authentification ──────────────────────────────────────────────────────

  /// Connexion avec email et mot de passe.
  /// Lance une [AuthException] en cas d'erreur.
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _client.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// Inscription avec email et mot de passe.
  /// Lance une [AuthException] en cas d'erreur.
  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    await _client.auth.signUp(
      email: email.trim(),
      password: password,
    );
  }

  /// Déconnexion de l'utilisateur courant.
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  // ─── Helper pour messages d'erreur lisibles ────────────────────────────────

  /// Convertit une [AuthException] en message lisible pour l'utilisateur.
  static String friendlyError(AuthException e) {
    switch (e.message) {
      case 'Invalid login credentials':
        return 'Email ou mot de passe incorrect.';
      case 'Email not confirmed':
        return 'Veuillez confirmer votre email avant de vous connecter.';
      case 'User already registered':
        return 'Un compte existe déjà avec cet email.';
      case 'Password should be at least 6 characters':
        return 'Le mot de passe doit contenir au moins 6 caractères.';
      default:
        return 'Erreur : ${e.message}';
    }
  }
}
