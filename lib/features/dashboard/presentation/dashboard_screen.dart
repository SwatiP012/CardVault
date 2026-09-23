import 'package:flutter/material.dart';
import 'package:practice/app/theme.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text('CardVault'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),

      body: const Center(
        child: Text(
          'Welcome to your CardVault Dashboard',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
