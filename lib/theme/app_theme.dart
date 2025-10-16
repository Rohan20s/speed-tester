import 'package:flutter/material.dart';

class AppTheme {
  // Color Palette
  static const Color primaryDark = Color(0xFF1A1A1A);
  static const Color secondaryDark = Color(0xFF2A2A2A);
  static const Color accentGreen = Color(0xFF00FF88);
  static const Color accentBlue = Color(0xFF2196F3);
  static const Color accentYellow = Color(0xFFFFC107);
  static const Color accentPurple = Color(0xFF9C27B0);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textTertiary = Color(0xFF757575);

  // Text Styles
  static const TextStyle headingLarge = TextStyle(
    color: textPrimary,
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle headingMedium = TextStyle(
    color: textPrimary,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle headingSmall = TextStyle(
    color: textPrimary,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle bodyLarge = TextStyle(
    color: textPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle bodyMedium = TextStyle(
    color: textSecondary,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodySmall = TextStyle(
    color: textTertiary,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle speedText = TextStyle(
    color: accentGreen,
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle speedUnit = TextStyle(
    color: textSecondary,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  // Button Styles
  static ButtonStyle primaryButton = ElevatedButton.styleFrom(
    backgroundColor: accentGreen,
    foregroundColor: Colors.black,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
  );

  static ButtonStyle stopButton = ElevatedButton.styleFrom(
    backgroundColor: Colors.red,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
  );

  // Card Styles
  static BoxDecoration cardDecoration = BoxDecoration(
    color: secondaryDark,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.3),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  );

  // Container Styles
  static BoxDecoration speedDialContainer = BoxDecoration(
    color: primaryDark,
    borderRadius: BorderRadius.circular(20),
  );

  // Theme Data
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: primaryDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryDark,
        foregroundColor: textPrimary,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: primaryButton,
      ),
      cardTheme: CardThemeData(
        color: secondaryDark,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: headingLarge,
        headlineMedium: headingMedium,
        headlineSmall: headingSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
      ),
    );
  }
}
