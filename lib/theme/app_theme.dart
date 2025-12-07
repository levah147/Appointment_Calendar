// ================================================================================
// FILE: lib/theme/app_theme.dart
// ================================================================================

import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme Colors
  static const Color lightPrimary = Color(0xFF6366F1);
  static const Color lightBackground = Color(0xFFF5F5F5);
  static const Color lightSurface = Colors.white;
  static const Color lightText = Color(0xFF1F2937);
  static const Color lightTextSecondary = Color(0xFF6B7280);
  static const Color lightBorder = Color(0xFFE5E7EB);
  static const Color lightGridLine = Color(0xFFE5E7EB);

  // Dark Theme Colors
  static const Color darkPrimary = Color(0xFF818CF8);
  static const Color darkBackground = Color(0xFF111827);
  static const Color darkSurface = Color(0xFF1F2937);
  static const Color darkText = Color(0xFFF9FAFB);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);
  static const Color darkBorder = Color(0xFF374151);
  static const Color darkGridLine = Color(0xFF374151);

  // Working Hours Background
  static const Color lightWorkingHours = Color(0xFFF0FDF4);
  static const Color darkWorkingHours = Color(0xFF064E3B);

  // Break Colors
  static const Color lightBreakBg = Color(0xFFFEF3C7);
  static const Color lightBreakBorder = Color(0xFFF59E0B);
  static const Color darkBreakBg = Color(0xFF78350F);
  static const Color darkBreakBorder = Color(0xFFFBBF24);

  // Unavailable Colors
  static const Color lightUnavailable = Color(0xFFE5E7EB);
  static const Color darkUnavailable = Color(0xFF374151);

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: lightPrimary,
    scaffoldBackgroundColor: lightBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: lightSurface,
      foregroundColor: lightText,
      elevation: 0,
    ),
    colorScheme: const ColorScheme.light(
      primary: lightPrimary,
      surface: lightSurface,
      background: lightBackground,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: lightText),
      bodyMedium: TextStyle(color: lightText),
      bodySmall: TextStyle(color: lightTextSecondary),
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: darkPrimary,
    scaffoldBackgroundColor: darkBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkSurface,
      foregroundColor: darkText,
      elevation: 0,
    ),
    colorScheme: const ColorScheme.dark(
      primary: darkPrimary,
      surface: darkSurface,
      background: darkBackground,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: darkText),
      bodyMedium: TextStyle(color: darkText),
      bodySmall: TextStyle(color: darkTextSecondary),
    ),
  );

  // Helper method to get colors based on context
  static Color getWorkingHoursColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightWorkingHours
        : darkWorkingHours;
  }

  static Color getBreakBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightBreakBg
        : darkBreakBg;
  }

  static Color getBreakBorderColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightBreakBorder
        : darkBreakBorder;
  }

  static Color getUnavailableColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightUnavailable
        : darkUnavailable;
  }

  static Color getGridLineColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightGridLine
        : darkGridLine;
  }

  static Color getBorderColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightBorder
        : darkBorder;
  }

  static Color getTimeTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightTextSecondary
        : darkTextSecondary;
  }
}
