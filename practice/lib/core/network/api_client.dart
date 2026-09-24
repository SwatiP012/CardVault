import 'dart:convert';

import 'package:http/http.dart' as http;

import '../errors/bank_error.dart';
import '../security/token_storage.dart';
import 'api_config.dart';

class ApiClient {
  final TokenStorage tokenStorage;

  const ApiClient({this.tokenStorage = const TokenStorage()});

  Future<Map<String, String>> _headers({
    Map<String, String>? additionalHeaders,
    bool authenticated = false,
  }) async {
    final headers = <String, String>{'Content-Type': 'application/json'};

    if (authenticated) {
      final token = await tokenStorage.getAccessToken();

      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    return headers;
  }

  Future<dynamic> get(String path, {bool authenticated = true}) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}$path'),
        headers: await _headers(authenticated: authenticated),
      );

      return _handleResponse(response);
    } catch (e) {
      if (e is BankError) {
        rethrow;
      }

      throw const BankError(
        code: BankErrorCode.network,
        message: 'Unable to connect to CardVault server.',
      );
    }
  }

  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    bool authenticated = false,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}$path'),
        headers: await _headers(
          additionalHeaders: headers,
          authenticated: authenticated,
        ),
        body: jsonEncode(body ?? {}),
      );

      return _handleResponse(response);
    } catch (e) {
      if (e is BankError) {
        rethrow;
      }

      throw const BankError(
        code: BankErrorCode.network,
        message: 'Unable to connect to CardVault server.',
      );
    }
  }

  Future<dynamic> put(
    String path, {
    Map<String, dynamic>? body,
    bool authenticated = true,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}$path'),
        headers: await _headers(authenticated: authenticated),
        body: jsonEncode(body ?? {}),
      );

      return _handleResponse(response);
    } catch (e) {
      if (e is BankError) {
        rethrow;
      }

      throw const BankError(
        code: BankErrorCode.network,
        message: 'Unable to connect to CardVault server.',
      );
    }
  }

  Future<dynamic> patch(
    String path, {
    Map<String, dynamic>? body,
    bool authenticated = true,
  }) async {
    try {
      final response = await http.patch(
        Uri.parse('${ApiConfig.baseUrl}$path'),
        headers: await _headers(authenticated: authenticated),
        body: jsonEncode(body ?? {}),
      );

      return _handleResponse(response);
    } catch (e) {
      if (e is BankError) {
        rethrow;
      }

      throw const BankError(
        code: BankErrorCode.network,
        message: 'Unable to connect to CardVault server.',
      );
    }
  }

  dynamic _handleResponse(http.Response response) {
    Map<String, dynamic> body;

    try {
      final decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic>) {
        body = decoded;
      } else {
        body = {};
      }
    } catch (_) {
      body = {};
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }

    if (response.statusCode == 401) {
      throw BankError(
        code: BankErrorCode.unauthorized,
        message: body['message'] ?? 'Authentication required.',
      );
    }

    if (response.statusCode == 403) {
      throw BankError(
        code: BankErrorCode.forbidden,
        message: body['message'] ?? 'Access denied.',
      );
    }

    if (response.statusCode == 404) {
      throw BankError(
        code: BankErrorCode.notFound,
        message: body['message'] ?? 'Endpoint not found.',
      );
    }

    if (response.statusCode == 409) {
      throw BankError(
        code: BankErrorCode.conflict,
        message: body['message'] ?? 'Request conflicts with current state.',
      );
    }

    if (response.statusCode >= 400 && response.statusCode < 500) {
      throw BankError(
        code: BankErrorCode.validation,
        message: body['message'] ?? 'Invalid request.',
      );
    }

    throw BankError(
      code: BankErrorCode.server,
      message: body['message'] ?? 'Server error.',
    );
  }
}
