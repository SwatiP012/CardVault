import 'package:flutter/foundation.dart';

import '../../../core/errors/bank_error.dart';
import '../../../core/network/api_client.dart';
import '../data/auth_repository.dart';
import '../domain/auth_session.dart';

import 'package:practice/core/security/token_storage.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository repository;

  AuthProvider({required this.repository});

  AuthSession? _session;
  bool _isLoading = false;
  BankError? _error;

  AuthSession? get session => _session;
  bool get isLoggedIn => _session != null;
  bool get isLoading => _isLoading;
  BankError? get error => _error;

  Future<bool> login({required String mobile, required String pin}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _session = await repository.login(mobile: mobile, pin: pin);

      return true;
    } on BankError catch (e) {
      _error = e;
      return false;
    } catch (_) {
      _error = const BankError(
        code: BankErrorCode.unknown,
        message: 'Unable to login.',
      );

      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _session = null;
    _error = null;
    notifyListeners();
  }
}

AuthProvider createAuthProvider() {
  const apiClient = ApiClient();
  const tokenStorage = TokenStorage();

  return AuthProvider(
    repository: AuthRepository(
      apiClient: apiClient,
      tokenStorage: tokenStorage,
    ),
  );
}
