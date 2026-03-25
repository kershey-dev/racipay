import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Base URL — MUST match host + port where Laravel listens:
//   php artisan serve (default) → port 8000:
//     Android emulator  → http://10.0.2.2:8000/api/v1
//     iOS simulator     → http://127.0.0.1:8000/api/v1
//   nginx/apache on :80  → omit :8000
//   Physical device     → http://<PC-LAN-IP>:8000/api/v1
// ─────────────────────────────────────────────────────────────────────────────
const String _baseUrl = 'http://10.0.2.2:8000/api/v1';

const _storage = FlutterSecureStorage();
const _tokenKey = 'auth_token';

Dio _buildDio() {
  final dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: _tokenKey);
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (kDebugMode) {
          final req = error.requestOptions;
          debugPrint(
            '[RACIPAY Dio] ${req.method} ${req.uri}',
          );
          debugPrint(
            '[RACIPAY Dio] type=${error.type} message=${error.message}',
          );
          final res = error.response;
          if (res != null) {
            debugPrint(
              '[RACIPAY Dio] status=${res.statusCode} data=${res.data}',
            );
          }
        }
        // Clear stored token on 401 so the next app start sends to login.
        if (error.response?.statusCode == 401) {
          await _storage.delete(key: _tokenKey);
        }
        handler.next(error);
      },
    ),
  );

  return dio;
}

/// Single Dio instance shared across the app via Riverpod.
final dioProvider = Provider<Dio>((_) => _buildDio());
