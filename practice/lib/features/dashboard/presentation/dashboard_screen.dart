import 'package:flutter/material.dart';

import '../../cards/presentation/card_screen.dart';

import '../../../app/theme.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'CardVault',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            const Text(
              'Hello, Swati ',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Manage your cards securely',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),

            const SizedBox(height: 28),

            // Section title
            const Text(
              'My Cards',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 14),

            // Card
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CardsScreen()),
                );
              },
              child: _buildCard(),
            ),

            const SizedBox(height: 24),

            // Card status
            _buildStatusCard(),

            const SizedBox(height: 28),

            // Quick actions
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: _buildAction(
                    icon: Icons.lock_outline_rounded,
                    title: 'Freeze',
                    onTap: () {},
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _buildAction(
                    icon: Icons.tune_rounded,
                    title: 'Controls',
                    onTap: () {},
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _buildAction(
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'Limits',
                    onTap: () {},
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Transactions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Transactions',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),

                TextButton(onPressed: () {}, child: const Text('View all')),
              ],
            ),

            const SizedBox(height: 8),

            _buildTransaction(
              icon: Icons.shopping_bag_outlined,
              title: 'Amazon',
              date: 'Today, 10:42 AM',
              amount: '- ₹1,299',
            ),

            _buildTransaction(
              icon: Icons.fastfood_outlined,
              title: 'Swiggy',
              date: 'Yesterday, 8:15 PM',
              amount: '- ₹450',
            ),

            _buildTransaction(
              icon: Icons.local_taxi_outlined,
              title: 'Uber',
              date: 'Yesterday, 6:30 PM',
              amount: '- ₹280',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard() {
    return Container(
      width: double.infinity,
      height: 205,
      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        borderRadius: BorderRadius.circular(22),

        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: .25),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // const Text(
              //   'CARDVAULT',
              //   style: TextStyle(
              //     color: Colors.white,
              //     fontSize: 13,
              //     fontWeight: FontWeight.bold,
              //     letterSpacing: 2,
              //   ),
              // ),

              Icon(
                Icons.contactless_rounded,
                color: Colors.white.withValues(alpha: .9),
                size: 28,
              ),
            ],
          ),

          const Spacer(),

          const Text(
            '****  ****  ****  4521',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              letterSpacing: 2,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CARD HOLDER',
                    style: TextStyle(color: Colors.white70, fontSize: 9),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'SWATI PATEL',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EXPIRES',
                    style: TextStyle(color: Colors.white70, fontSize: 9),
                  ),
                  SizedBox(height: 3),
                  Text(
                    '12/29',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'DEBIT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),

      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,

            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: .1),
              shape: BoxShape.circle,
            ),

            child: const Icon(Icons.check_rounded, color: AppColors.success),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Card is active',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'All card transactions are enabled',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildAction({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      borderRadius: BorderRadius.circular(16),

      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),

        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),

        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 25),

            const SizedBox(height: 8),

            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransaction({
    required IconData icon,
    required String title,
    required String date,
    required String amount,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),

      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),

      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,

            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(icon, color: AppColors.primary),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          Text(
            amount,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
