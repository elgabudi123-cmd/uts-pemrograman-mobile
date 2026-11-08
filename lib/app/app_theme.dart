import 'package:flutter/material.dart';

class AppTheme {
  static const background = Color(0xFFEFFDF5);
  static const primary = Color(0xFF006B56);
  static const primaryDark = Color(0xFF005B49);
  static const surfaceLow = Color(0xFFE9F7EF);
  static const surface = Color(0xFFFFFFFF);
  static const text = Color(0xFF121E1A);
  static const secondaryText = Color(0xFF5E6D66);
  static const outline = Color(0xFFBDCCC3);
  static const blue = Color(0xFF1565C0);
  static const red = Color(0xFFC6382A);

  static ThemeData get theme {
    final scheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
      surface: background,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme.copyWith(
        primary: primary,
        onPrimary: Colors.white,
        surface: background,
        onSurface: text,
        secondary: const Color(0xFF188565),
        outline: outline,
      ),
      scaffoldBackgroundColor: background,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: text,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 15,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: background,
        indicatorColor: const Color(0xFFDCEFE5),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
