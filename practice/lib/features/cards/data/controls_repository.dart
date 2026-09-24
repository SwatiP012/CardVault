import '../../../core/network/api_client.dart';
import '../domain/card_controls.dart';

class ControlsRepository {
  final ApiClient apiClient;

  const ControlsRepository({required this.apiClient});

  Future<CardControls> getControls(String cardId) async {
    final response = await apiClient.get('/cards/$cardId/controls');

    return CardControls.fromJson(response as Map<String, dynamic>);
  }

  Future<CardControls> updateControls({
    required String cardId,
    required CardControls controls,
  }) async {
    final response = await apiClient.put(
      '/cards/$cardId/controls',
      body: controls.toJson(),
    );

    return CardControls.fromJson(response as Map<String, dynamic>);
  }
}
