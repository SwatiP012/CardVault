import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:practice/app/theme.dart';
import 'package:practice/core/security/biometric_security.dart';
import 'package:practice/features/cards/domain/card_controls.dart';
import 'package:practice/features/cards/domain/card_model.dart';
import 'package:practice/features/cards/state/cards_control_provider.dart';
import 'package:practice/features/cards/state/cards_provider.dart';
import 'package:practice/features/cards/widgets/card_visuals.dart';

class CardDetailsScreen extends StatefulWidget {
  final CardModel card;

  const CardDetailsScreen({super.key, required this.card});

  @override
  State<CardDetailsScreen> createState() => _CardDetailsScreenState();
}

class _CardDetailsScreenState extends State<CardDetailsScreen> {
  final BiometricService _biometricService = BiometricService();

  @override
  Widget build(BuildContext context) {
    final currentCard = context.watch<CardsProvider>().getCardById(
      widget.card.id,
    );

    if (currentCard == null) {
      return const Scaffold(body: Center(child: Text('Card not found')));
    }

    return ChangeNotifierProvider(
      create: (_) => createCardControlsProvider()..loadControls(widget.card.id),
      child: _buildScreen(currentCard),
    );
  }

  Widget _buildScreen(CardModel currentCard) {
    final controls = context.watch<CardControlsProvider>().getControls(
      widget.card.id,
    );

    final isFrozen = currentCard.status == CardStatus.frozen;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Card Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CardVisual(card: currentCard),

            const SizedBox(height: 24),

            _buildStatusCard(currentCard),

            const SizedBox(height: 28),

            const Text(
              'Card Controls',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 12),

            if (controls == null)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: CircularProgressIndicator()),
              )
            else ...[
              _buildSwitchTile(
                icon: Icons.shopping_bag_outlined,
                title: 'Online Payments',
                subtitle: 'Allow online card transactions',
                value: controls.online,
                isFrozen: isFrozen,
                onChanged: (value) {
                  _updateControl(controls.copyWith(online: value));
                },
              ),

              _buildSwitchTile(
                icon: Icons.public_rounded,
                title: 'International Payments',
                subtitle: 'Allow transactions outside India',
                value: controls.international,
                isFrozen: isFrozen,
                onChanged: (value) {
                  _updateControl(controls.copyWith(international: value));
                },
              ),

              _buildSwitchTile(
                icon: Icons.contactless_rounded,
                title: 'Contactless Payments',
                subtitle: 'Allow tap-to-pay transactions',
                value: controls.contactless,
                isFrozen: isFrozen,
                onChanged: (value) {
                  _updateControl(controls.copyWith(contactless: value));
                },
              ),

              _buildSwitchTile(
                icon: Icons.atm_rounded,
                title: 'ATM Withdrawals',
                subtitle: 'Allow cash withdrawals',
                value: controls.atm,
                isFrozen: isFrozen,
                onChanged: (value) {
                  _updateControl(controls.copyWith(atm: value));
                },
              ),
            ],

            const SizedBox(height: 28),

            const Text(
              'Transaction Limits',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 12),

            _buildLimitTile(
              icon: Icons.atm_rounded,
              title: 'ATM Withdrawal',
              amount: '₹20,000',
            ),

            _buildLimitTile(
              icon: Icons.shopping_cart_outlined,
              title: 'Online Transactions',
              amount: '₹50,000',
            ),

            _buildLimitTile(
              icon: Icons.storefront_outlined,
              title: 'POS Transactions',
              amount: '₹30,000',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateControl(CardControls newControls) async {
    final provider = context.read<CardControlsProvider>();

    final success = await provider.updateControlsOptimistically(
      cardId: widget.card.id,
      newControls: newControls,
    );

    if (!mounted) {
      return;
    }

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to save control. The previous setting has been restored.',
          ),
        ),
      );
    }
  }

  Future<void> _showFreezeConfirmation() async {
    final cardsProvider = context.read<CardsProvider>();

    final currentCard = cardsProvider.getCardById(widget.card.id);

    if (currentCard == null) {
      return;
    }

    final currentStatus = currentCard.status;

    final newStatus = currentStatus == CardStatus.frozen
        ? CardStatus.active
        : CardStatus.frozen;

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final isCurrentlyFrozen = currentStatus == CardStatus.frozen;

        return AlertDialog(
          title: Text(isCurrentlyFrozen ? 'Unfreeze Card?' : 'Freeze Card?'),
          content: Text(
            isCurrentlyFrozen
                ? 'Your card will be activated again and transactions will be enabled.'
                : 'Your card will be temporarily frozen. Card transactions will be disabled until you unfreeze it.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(isCurrentlyFrozen ? 'Unfreeze' : 'Freeze'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    if (newStatus == CardStatus.frozen) {
      final authenticated = await _biometricService.authenticate(
        reason: 'Authenticate to freeze your card',
      );

      if (!mounted || !authenticated) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Biometric authentication failed or was cancelled.',
              ),
            ),
          );
        }

        return;
      }
    }

    final success = await cardsProvider.updateCardStatusOptimistically(
      cardId: widget.card.id,
      newStatus: newStatus,
    );

    if (!mounted) {
      return;
    }

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newStatus == CardStatus.frozen
                ? 'Card frozen successfully.'
                : 'Card unfrozen successfully.',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            cardsProvider.error?.message ?? 'Unable to update card status.',
          ),
        ),
      );
    }
  }

  Widget _buildStatusCard(CardModel currentCard) {
    final isFrozen = currentCard.status == CardStatus.frozen;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: (isFrozen ? AppColors.error : AppColors.success)
                  .withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isFrozen ? Icons.lock_outline_rounded : Icons.check_rounded,
              color: isFrozen ? AppColors.error : AppColors.success,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isFrozen ? 'Card is frozen' : 'Card is active',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  isFrozen
                      ? 'Transactions are temporarily disabled'
                      : 'All card transactions are enabled',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          TextButton(
            onPressed: _showFreezeConfirmation,
            child: Text(
              isFrozen ? 'Unfreeze' : 'Freeze',
              style: TextStyle(
                color: isFrozen ? AppColors.success : AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool isFrozen,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: isFrozen ? null : onChanged,
        secondary: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
        activeThumbColor: AppColors.primary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
    );
  }

  Widget _buildLimitTile({
    required IconData icon,
    required String title,
    required String amount,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          Text(
            amount,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(width: 8),

          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
