import 'package:flutter/material.dart';

class CardVaultApp extends StatelessWidget {
  const CardVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CardVault',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00695C)),
        scaffoldBackgroundColor: const Color(0xFFF7F9F9),
      ),

      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00695C),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.credit_card_rounded,
                    color: Colors.white,
                    size: 50,
                  ),
                ),

                const SizedBox(height: 24),

                // App name
                const Text(
                  'CardVault',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),

                const SizedBox(height: 10),

                // Tagline
                Text(
                  'Your cards. Your control.',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),

                const SizedBox(height: 40),

                // Welcome message
                const Text(
                  'Welcome to CardVault',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 10),

                Text(
                  'Manage your debit and credit cards\n'
                  'securely from one place.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 40),

                // Temporary button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      // Login/dashboard will be added later.
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00695C),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
