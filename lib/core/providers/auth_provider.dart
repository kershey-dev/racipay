import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Auth state:
//   AsyncData(null)    → no session / logged out
//   AsyncData(user)    → authenticated
//   AsyncLoading()     → login / session restore in progress
//   AsyncError(e, st)  → login failed
// ─────────────────────────────────────────────────────────────────────────────

class AuthNotifier extends AsyncNotifier<UserModel?> {
  @override
  Future<UserModel?> build() async => null;

  // ── Login ──────────────────────────────────────────────────────────────────
  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authServiceProvider).login(email, password),
    );
  }

  // ── Restore session on app startup ─────────────────────────────────────────
  /// Checks stored token; if valid, fetches user from /auth/me.
  /// On any error (network, 401, etc.) silently lands on login screen.
  Future<void> restoreSession() async {
    final service = ref.read(authServiceProvider);

    if (!await service.hasStoredToken()) {
      state = const AsyncData(null);
      return;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() => service.getMe());

    // If getMe failed (expired/invalid token), treat as logged out.
    if (state.hasError) {
      state = const AsyncData(null);
    }
  }

  // ── Logout ─────────────────────────────────────────────────────────────────
  Future<void> logout() async {
    await ref.read(authServiceProvider).logout();
    state = const AsyncData(null);
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, UserModel?>(
  AuthNotifier.new,
);
