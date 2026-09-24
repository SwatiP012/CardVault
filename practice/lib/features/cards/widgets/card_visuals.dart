import 'package:flutter/material.dart';

import '../domain/card_model.dart';

class CardVisual extends StatelessWidget {
  final CardModel card;

  const CardVisual({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    final bool isFrozen = card.status == CardStatus.frozen;
    final bool isBlocked = card.status == CardStatus.blocked;

    return Container(
      width: double.infinity,
      height: 210,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF00695C), Color(0xFF003C36)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // const Text(
                  //   'CARDVAULT',
                  //   style: TextStyle(
                  //     color: Colors.white,
                  //     fontSize: 16,
                  //     fontWeight: FontWeight.bold,
                  //     letterSpacing: 2,
                  //   ),
                  // ),
                  Text(
                    card.network,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              Text(
                card.maskedNumber,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  letterSpacing: 1.5,
                ),
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    card.type == CardType.credit ? 'CREDIT CARD' : 'DEBIT CARD',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    card.expiry,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),

          if (isFrozen || isBlocked)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.58),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      isFrozen ? 'FROZEN' : 'BLOCKED',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
