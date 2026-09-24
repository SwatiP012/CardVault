import '../../../core/network/api_client.dart';
import '../domain/card_model.dart';

class CardRepository {
  final ApiClient apiClient;

  const CardRepository({required this.apiClient});

  Future<List<CardModel>> getCards() async {
    final response = await apiClient.get('/cards');

    final cards = response as List<dynamic>;

    return cards
        .map((json) => CardModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<CardModel> updateCardStatus({
    required String cardId,
    required CardStatus status,
  }) async {
    final response = await apiClient.patch(
      '/cards/$cardId/status',
      body: {'status': status.name.toUpperCase()},
    );

    return CardModel.fromJson(response as Map<String, dynamic>);
  }
}
