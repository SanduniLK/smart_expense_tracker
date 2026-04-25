import 'package:flutter/material.dart';

class AppColors {
  // Main Colors
  static const Color primaryIndigo = Color(0xFF303F9F); // shade700
  static const Color secondaryIndigo = Color(0xFF3F51B5); // shade500
  
  // Gradient
  static final List<Color> mainGradient = [
    primaryIndigo,
    secondaryIndigo,
  ];
static final Color indigo50 = Colors.indigo.shade50;
static final Color indigo100 = Colors.indigo.shade100;
static final Color indigo400 = Colors.indigo.shade400;
static final Color indigo700 = Colors.indigo.shade700;
  // Functional Colors

  static const Color textWhite = Colors.white;
  static final Color textWhite70 = Colors.white.withOpacity(0.7);
  static final Color textWhite60 = Colors.white.withOpacity(0.6);
  static final Color dividerWhite = Colors.white24;
  static final Color indigoBg = Colors.indigo.shade50;
  static final Color expenseRedBg = Colors.red.shade50;
  static final Color incomeGreenBg = Colors.green.shade50;
  static final Color borderGrey = Colors.grey.shade200;
  static final Color textGrey = Colors.grey.shade500;
  static const Color darkBlue = Color(0xFF1A1A2E);

  
  static final Color iconLight = Colors.grey.shade300;
  static final Color textLight = Colors.grey.shade400;
  // Status Colors
  static final Color incomeGreen = Colors.greenAccent.shade200;
  static final Color expenseRed = Colors.redAccent.shade100;
  static const Color cardBg = Colors.white;
  static const Color scaffoldBg = Color(0xFFF7F8FC);
  
  // Shadow
  static final Color shadowColor = primaryIndigo.withOpacity(0.3);
}