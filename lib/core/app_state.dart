import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Représente l'état global de l'UI (chargement, erreur, etc.)
class AppUIState {
  final bool isLoading;
  final String? errorMessage;

  AppUIState({this.isLoading = false, this.errorMessage});

  AppUIState copyWith({bool? isLoading, String? errorMessage}) {
    return AppUIState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class AppUIStateNotifier extends StateNotifier<AppUIState> {
  AppUIStateNotifier() : super(AppUIState());

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void setError(String? message) {
    state = state.copyWith(errorMessage: message);
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

/// Provider pour gérer l'état global de l'interface utilisateur.
final appUIStateProvider = StateNotifierProvider<AppUIStateNotifier, AppUIState>((ref) {
  return AppUIStateNotifier();
});
