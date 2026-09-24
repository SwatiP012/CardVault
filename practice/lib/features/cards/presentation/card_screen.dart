import 'package:flutter/material.dart';
import 'package:practice/features/cards/domain/card_model.dart';
import 'package:practice/features/cards/presentation/card_details_screen.dart';
import 'package:practice/features/cards/state/cards_provider.dart';
import 'package:practice/features/cards/widgets/card_visuals.dart';
import 'package:provider/provider.dart';

// import '../../../app/theme.dart';
// import '../widgets/card_visuals.dart';

class CardsScreen extends StatelessWidget {
  const CardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cardsProvider = context.watch<CardsProvider>();

    if (cardsProvider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (cardsProvider.error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Cards')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(cardsProvider.error!.message),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: cardsProvider.loadCards,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final cards = cardsProvider.cards;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9F9),
        elevation: 0,
        title: const Text('My Cards'),
      ),
      body: cards.isEmpty
          ? const Center(child: Text('No cards available'))
          : Column(
              children: [
                const SizedBox(height: 20),

                SizedBox(
                  height: 230,
                  child: PageView.builder(
                    controller: PageController(viewportFraction: 0.88),
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      final card = cards[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CardDetailsScreen(card: card),
                              ),
                            );
                          },
                          child: CardVisual(card: card),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 14),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    cards.length,
                    (index) => Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index == 0
                            ? const Color(0xFF00695C)
                            : Colors.grey.shade300,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      final card = cards[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: Icon(
                            card.type == CardType.credit
                                ? Icons.credit_card
                                : Icons.credit_card_outlined,
                            color: const Color(0xFF00695C),
                          ),
                          title: Text(
                            card.type == CardType.credit
                                ? 'Credit Card'
                                : 'Debit Card',
                          ),
                          subtitle: Text(
                            '${card.network} • ${card.maskedNumber}',
                          ),
                          trailing: Text(card.status.name.toUpperCase()),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
