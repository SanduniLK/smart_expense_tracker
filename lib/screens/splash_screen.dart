import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_expense_tracker/utils/app_colors.dart'; // AppColors import කරන්න
import 'transaction_list_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // තත්පර 3කට පසු List Screen එකට මාරු වීම
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TransactionListScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // මුළු screen එකටම gradient එකක් ලබා දෙමු
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.mainGradient, // Indigo Gradient එක
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ලස්සන Icon එකක්
            const Icon(
              Icons.account_balance_wallet_rounded,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            // App එකේ නම
            Text(
              "SmartExpense",
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            // පොඩි Tagline එකක්
            Text(
              "Automated SMS Expense Tracker",
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 60),
            // Loading පෙන්වීමට - සුදු පාටින්
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}