import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryGreen = Color(0xFF00D46A);
  static const Color primaryBlue = Color(0xFF0055FF);
  static const Color darkNavy = Color(0xFF0D1B2A);
  static const Color subtitleGray = Color(0xFF64748B);
  static const Color borderGray = Color(0xFFE2E8F0);
  static const Color dotInactive = Color(0xFFE2E8F0);
  static const Color cardBg = Color(0xFFF8FAFC);
  static const Color surfaceWhite = Color(0xFFFFFFFF);

  // Gradient
  static const LinearGradient brandGradient = LinearGradient(
    colors: [primaryBlue, primaryGreen],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient brandGradientVertical = LinearGradient(
    colors: [primaryBlue, primaryGreen],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: surfaceWhite,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        primary: primaryGreen,
        secondary: primaryBlue,
        surface: surfaceWhite,
      ),
      fontFamily: 'PlusJakartaSans',
    );
  }
}
