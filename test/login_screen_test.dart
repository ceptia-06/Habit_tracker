import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/features/auth/presentation/login_screen.dart';

void main() {
  testWidgets('LoginScreen should display email and password fields', (WidgetTester tester) async {
    // On enveloppe dans ProviderScope car LoginScreen est un ConsumerWidget
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    // Vérifie la présence des champs
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Mot de passe'), findsOneWidget);
    expect(find.text('Se connecter'), findsOneWidget);
  });

  testWidgets('Validation error should appear if fields are empty', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    // Appui sur le bouton sans rien remplir
    await tester.tap(find.text('Se connecter'));
    await tester.pump(); // Déclenche le rebuild pour la validation

    // Vérifie que les messages d'erreur s'affichent
    expect(find.text('Email requis'), findsOneWidget);
    expect(find.text('Mot de passe requis'), findsOneWidget);
  });
}
