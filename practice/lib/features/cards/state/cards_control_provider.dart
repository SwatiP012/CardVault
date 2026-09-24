import 'package:flutter/foundation.dart';
import 'package:practice/core/network/api_client.dart';

import '../../../core/errors/bank_error.dart';
import '../data/controls_repository.dart';
import '../domain/card_controls.dart';

class CardControlsProvider extends ChangeNotifier {
  final ControlsRepository repository;

  CardControlsProvider({required this.repository});

  final Map<String, CardControls> _controls = {};

  CardControls? getControls(String cardId) {
    return _controls[cardId];
  }

  Future<void> loadControls(String cardId) async {
    try {
      final controls = await repository.getControls(cardId);

      _controls[cardId] = controls;

      notifyListeners();
    } on BankError {
      rethrow;
    }
  }

  Future<bool> updateControlsOptimistically({
    required String cardId,
    required CardControls newControls,
  }) async {
    final previousControls = _controls[cardId];

    // Immediately update the UI.
    _controls[cardId] = newControls;
    notifyListeners();

    try {
      final savedControls = await repository.updateControls(
        cardId: cardId,
        controls: newControls,
      );

      // Server response becomes the final state.
      _controls[cardId] = savedControls;
      notifyListeners();

      return true;
    } on BankError {
      // Roll back only this card's controls.
      if (previousControls != null) {
        _controls[cardId] = previousControls;
      } else {
        _controls.remove(cardId);
      }

      notifyListeners();

      return false;
    } catch (_) {
      if (previousControls != null) {
        _controls[cardId] = previousControls;
      } else {
        _controls.remove(cardId);
      }

      notifyListeners();

      return false;
    }
  }
}

CardControlsProvider createCardControlsProvider() {
  const apiClient = ApiClient();

  return CardControlsProvider(
    repository: ControlsRepository(apiClient: apiClient),
  );
}
