import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  late AnimationController _formController;
  late Animation<double> _formFade;
  late Animation<Offset> _formSlide;

  @override
  void initState() {
    super.initState();
    _formController = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _formFade = CurvedAnimation(parent: _formController, curve: Curves.easeOut);
    _formSlide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _formController, curve: Curves.easeOutCubic));
    _formController.forward();
  }

  @override
  void dispose() {
    _formController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await _authService.signUp(email: _emailController.text, password: _passwordController.text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(children: [Icon(Icons.check_circle_outline, color: Colors.white, size: 18), SizedBox(width: 10), Text('Compte créé avec succès !')]),
            backgroundColor: const Color(0xFF38A169),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
        Navigator.pop(context);
      }
    } on AuthException catch (e) {
      if (mounted) _showError(AuthService.friendlyError(e));
    } catch (_) {
      if (mounted) _showError('Une erreur inattendue est survenue.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [const Icon(Icons.error_outline, color: Colors.white, size: 18), const SizedBox(width: 10), Expanded(child: Text(message))]),
        backgroundColor: const Color(0xFFE53E3E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fond dégradé statique (même ambiance que Login)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0D0D1A), Color(0xFF1A1035), Color(0xFF0D1A2A)],
              ),
            ),
          ),
          // Orbe déco
          Positioned(top: -80, right: -80,
            child: Container(width: 300, height: 300,
              decoration: BoxDecoration(shape: BoxShape.circle,
                color: const Color(0xFF667EEA).withValues(alpha: 0.12),
                boxShadow: [BoxShadow(color: const Color(0xFF667EEA).withValues(alpha: 0.2), blurRadius: 100)],
              ),
            ),
          ),
          Positioned(bottom: -60, left: -60,
            child: Container(width: 250, height: 250,
              decoration: BoxDecoration(shape: BoxShape.circle,
                color: const Color(0xFF764BA2).withValues(alpha: 0.12),
                boxShadow: [BoxShadow(color: const Color(0xFF764BA2).withValues(alpha: 0.2), blurRadius: 100)],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // App bar custom
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white.withValues(alpha: 0.08),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                          ),
                          child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white.withValues(alpha: 0.8), size: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                    child: FadeTransition(
                      opacity: _formFade,
                      child: SlideTransition(
                        position: _formSlide,
                        child: Column(
                          children: [
                            // Icône
                            Container(
                              width: 70, height: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(colors: [Color(0xFF06B6D4), Color(0xFF667EEA)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                                boxShadow: [BoxShadow(color: const Color(0xFF06B6D4).withValues(alpha: 0.4), blurRadius: 25, offset: const Offset(0, 8))],
                              ),
                              child: const Icon(Icons.person_add_alt_1_rounded, color: Colors.white, size: 32),
                            ),
                            const SizedBox(height: 20),
                            const Text('Créer un compte', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.5)),
                            const SizedBox(height: 6),
                            Text('Rejoins des milliers d\'utilisateurs ✨', style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.5))),
                            const SizedBox(height: 32),

                            // Card
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                color: Colors.white.withValues(alpha: 0.07),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 40, offset: const Offset(0, 20))],
                              ),
                              padding: const EdgeInsets.all(28),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    _buildField(controller: _emailController, label: 'Email', icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress,
                                      validator: (v) {
                                        if (v == null || v.trim().isEmpty) return 'Email requis';
                                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim())) return 'Email invalide';
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 14),
                                    _buildField(controller: _passwordController, label: 'Mot de passe', icon: Icons.lock_outline, obscureText: _obscurePassword,
                                      onToggleObscure: () => setState(() => _obscurePassword = !_obscurePassword),
                                      validator: (v) {
                                        if (v == null || v.isEmpty) return 'Mot de passe requis';
                                        if (v.length < 6) return 'Minimum 6 caractères';
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 14),
                                    _buildField(controller: _confirmController, label: 'Confirmer le mot de passe', icon: Icons.lock_outline, obscureText: _obscureConfirm,
                                      onToggleObscure: () => setState(() => _obscureConfirm = !_obscureConfirm),
                                      onFieldSubmitted: (_) => _signUp(),
                                      validator: (v) {
                                        if (v == null || v.isEmpty) return 'Confirmation requise';
                                        if (v != _passwordController.text) return 'Les mots de passe ne correspondent pas';
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 28),
                                    GestureDetector(
                                      onTap: _isLoading ? null : _signUp,
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        height: 52,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(14),
                                          gradient: !_isLoading ? const LinearGradient(colors: [Color(0xFF06B6D4), Color(0xFF667EEA)], begin: Alignment.centerLeft, end: Alignment.centerRight) : null,
                                          color: _isLoading ? Colors.white12 : null,
                                          boxShadow: !_isLoading ? [BoxShadow(color: const Color(0xFF06B6D4).withValues(alpha: 0.4), blurRadius: 20, offset: const Offset(0, 8))] : null,
                                        ),
                                        child: Center(
                                          child: _isLoading
                                              ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                              : const Text("S'inscrire", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: 0.3)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Déjà un compte ? ', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 13)),
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: const Text('Se connecter', style: TextStyle(color: Color(0xFF667EEA), fontWeight: FontWeight.w600, fontSize: 13)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    VoidCallback? onToggleObscure,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String)? onFieldSubmitted,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onFieldSubmitted: onFieldSubmitted,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 13),
        prefixIcon: Icon(icon, color: Colors.white.withValues(alpha: 0.4), size: 18),
        suffixIcon: onToggleObscure != null ? IconButton(
          icon: Icon(obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: Colors.white.withValues(alpha: 0.4), size: 18),
          onPressed: onToggleObscure,
        ) : null,
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.07),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF667EEA), width: 1.5)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE53E3E))),
        errorStyle: const TextStyle(color: Color(0xFFFC8181), fontSize: 11),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
