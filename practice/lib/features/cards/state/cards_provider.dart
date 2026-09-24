import 'package:flutter/foundation.dart';

import '../../../core/errors/bank_error.dart';
import '../../../core/network/api_client.dart';
import '../data/card_repository.dart';
import '../domain/card_model.dart';

class CardsProvider extends ChangeNotifier {
  final CardRepository repository;

  CardsProvider({required this.repository});

  List<CardModel> _cards = [];
  bool _isLoading = false;
  BankError? _error;

  List<CardModel> get cards => List.unmodifiable(_cards);

  bool get isLoading => _isLoading;

  BankError? get error => _error;

  Future<void> loadCards() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _cards = await repository.getCards();
    } on BankError catch (e) {
      _error = e;
    } catch (_) {
      _error = const BankError(
        code: BankErrorCode.unknown,
        message: 'Something went wrong while loading cards.',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  CardModel? getCardById(String cardId) {
    for (final card in _cards) {
      if (card.id == cardId) {
        return card;
      }
    }

    return null;
  }

  Future<bool> updateCardStatusOptimistically({
    required String cardId,
    required CardStatus newStatus,
  }) async {
    final index = _cards.indexWhere((card) => card.id == cardId);

    if (index == -1) {
      return false;
    }

    final previousCard = _cards[index];

    // Optimistic update: change UI immediately.
    _cards[index] = previousCard.copyWith(status: newStatus);

    notifyListeners();

    try {
      final updatedCard = await repository.updateCardStatus(
        cardId: cardId,
        status: newStatus,
      );

      // Server response is the final truth.
      _cards[index] = updatedCard;

      notifyListeners();

      return true;
    } on BankError catch (e) {
      // Server rejected the change → rollback.
      _cards[index] = previousCard;

      _error = e;
      notifyListeners();

      return false;
    } catch (_) {
      // Unexpected error → rollback.
      _cards[index] = previousCard;

      _error = const BankError(
        code: BankErrorCode.unknown,
        message: 'Unable to update card status.',
      );

      notifyListeners();

      return false;
    }
  }
}

CardsProvider createCardsProvider() {
  const apiClient = ApiClient();

  return CardsProvider(repository: CardRepository(apiClient: apiClient));
}
