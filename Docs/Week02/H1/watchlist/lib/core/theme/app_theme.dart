import 'package:flutter/material.dart';

class AppTheme {
  static const Color seedColor = Color(0xFF474C63);
  static const Color backgroundColor = Color(0xFF222933);
  static const Color cardColor = Color(0xFF2D3543);
  static const Color accentColor = Color(0xFFFF6B8A); // Rose

  static const Color watchingColor = Color(0xFF5BC0EB);
  static const Color completedColor = Color(0xFF6BCB9A);
  static const Color planColor = Color(0xFFB39DDB);
  static const Color ratingColor = Color(0xFFFFC857);
  static const Color onAccent = Color(0xFF2A0A14);

  static Color statusColor(String status) {
    switch (status) {
      case 'Watching':
        return watchingColor;
      case 'Completed':
        return completedColor;
      case 'Plan':
        return planColor;
      default:
        return accentColor;
    }
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.dark,
        surface: backgroundColor,
        primary: accentColor,
        onPrimary: onAccent,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      chipTheme: ChipThemeData(
        selectedColor: accentColor.withValues(alpha: 0.25),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
        checkmarkColor: accentColor,
        labelStyle: const TextStyle(fontWeight: FontWeight.w500),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor: accentColor,
          selectedForegroundColor: onAccent,
          side: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
        ),
      ),
    );
  }
}