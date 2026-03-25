import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/user_model.dart';
import '../network/api_client.dart';
import '../utils/auth_role.dart';

const _tokenKey = 'auth_token';

/// Thrown when the API returns a user whose [role] is not allowed in this app.
class UnsupportedAppRoleException implements Exception {
  const UnsupportedAppRoleException(this.role);
  final String role;

  @override
  String toString() =>
      'UnsupportedAppRoleException: $role (only subscriber and lineman are supported)';
}

class AuthService {
  AuthService(this._dio);

  final Dio _dio;
  final _storage = const FlutterSecureStorage();

  UserModel _decodeAndValidateUser(Map<String, dynamic> map) {
    final user = UserModel.fromJson(map);
    if (!isSupportedAppRole(user.role)) {
      throw UnsupportedAppRoleException(user.role);
    }
    return user;
  }

  // ── Login ──────────────────────────────────────────────────────────────────
  /// POST /auth/login  →  store token  →  GET /auth/me  →  return UserModel
  Future<UserModel> login(String email, String password) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: {'email': email, 'password': password},
    );

    final body = response.data!;

    // Accept both 'token' and 'access_token' key names.
    final token = (body['token'] ?? body['access_token']) as String?;
    if (token == null || token.isEmpty) {
      throw Exception('No token received from server.');
    }

    await _storage.write(key: _tokenKey, value: token);

    try {
      final userJson = body['user'] ?? body['data'];
      if (userJson != null) {
        return _decodeAndValidateUser(userJson as Map<String, dynamic>);
      }
      return await getMe();
    } catch (_) {
      await _storage.delete(key: _tokenKey);
      rethrow;
    }
  }

  // ── Get current user ───────────────────────────────────────────────────────
  /// GET /auth/me  →  return UserModel
  Future<UserModel> getMe() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/auth/me');
      final body = response.data!;

      // Support: { user: {...} } | { data: {...} } | { ...fields... }
      final userJson = body['user'] ?? body['data'] ?? body;
      return _decodeAndValidateUser(userJson as Map<String, dynamic>);
    } on UnsupportedAppRoleException {
      await _storage.delete(key: _tokenKey);
      rethrow;
    }
  }

  // ── Logout ─────────────────────────────────────────────────────────────────
  /// POST /auth/logout (best-effort), then clear local token.
  Future<void> logout() async {
    try {
      await _dio.post<void>('/auth/logout');
    } catch (_) {
      // Server logout is best-effort; local cleanup always runs.
    } finally {
      await _storage.delete(key: _tokenKey);
    }
  }

  // ── Token helpers ──────────────────────────────────────────────────────────
  Future<bool> hasStoredToken() async {
    final token = await _storage.read(key: _tokenKey);
    return token != null && token.isNotEmpty;
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.read(dioProvider));
});
