import '../../../core/network/api_client.dart';
import '../../../core/security/token_storage.dart';
import '../domain/auth_session.dart';

class AuthRepository {
  final ApiClient apiClient;
  final TokenStorage tokenStorage;

  const AuthRepository({required this.apiClient, required this.tokenStorage});

  Future<AuthSession> login({
    required String mobile,
    required String pin,
  }) async {
    final response = await apiClient.post(
      '/login',
      body: {'mobile': mobile, 'pin': pin},
    );

    final accessToken = response['accessToken'] as String;
    final userId = response['userId'] as String;

    // Securely store the JWT.
    await tokenStorage.saveAccessToken(accessToken);

    return AuthSession(accessToken: accessToken, userId: userId);
  }

  Future<void> logout() async {
    await tokenStorage.clearAccessToken();
  }
}
