import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Brand Colors
  static const Color primaryColor = Color(0xFF1A73E8);
  static const Color secondaryColor = Color(0xFF00C853);
  static const Color accentColor = Color(0xFF6200EE);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color warningColor = Color(0xFFFFA000);
  static const Color successColor = Color(0xFF00C853);
  static const Color infoColor = Color(0xFF2196F3);

  // Dark Theme Colors
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkCard = Color(0xFF252525);
  static const Color darkDivider = Color(0xFF323232);

  // Light Theme Colors
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightBackground = Color(0xFFF5F5F5);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightDivider = Color(0xFFE0E0E0);

  // Category Colors
  static const Map<String, Color> categoryColors = {
    'Food': Color(0xFFFF6B6B),
    'Travel': Color(0xFF4ECDC4),
    'Shopping': Color(0xFFFF8A80),
    'Tea': Color(0xFFA8E6CF),
    'Entertainment': Color(0xFFFFD93D),
    'Medical': Color(0xFF6C5CE7),
    'Internet': Color(0xFF74B9FF),
    'Mobile Recharge': Color(0xFFA29BFE),
    'Electricity': Color(0xFFFF7675),
    'Training Materials': Color(0xFF55EFC4),
    'Project Components': Color(0xFF81ECEC),
    'Room Rent': Color(0xFFE17055),
    'Emergency': Color(0xFFD63031),
    'Others': Color(0xFF636E72),
  };

  // Expense Category Icons
  static const Map<String, IconData> categoryIcons = {
    'Food': Icons.restaurant,
    'Travel': Icons.directions_bus,
    'Shopping': Icons.shopping_bag,
    'Tea': Icons.local_cafe,
    'Entertainment': Icons.movie,
    'Medical': Icons.medical_services,
    'Internet': Icons.wifi,
    'Mobile Recharge': Icons.phone_android,
    'Electricity': Icons.bolt,
    'Training Materials': Icons.school,
    'Project Components': Icons.build_circle,
    'Room Rent': Icons.home,
    'Emergency': Icons.warning,
    'Others': Icons.more_horiz,
  };

  // Health Score Colors
  static Color getHealthScoreColor(double score) {
    if (score >= 80) return successColor;
    if (score >= 60) return secondaryColor;
    if (score >= 40) return warningColor;
    return errorColor;
  }

  // Health Score Emoji
  static String getHealthScoreEmoji(double score) {
    if (score >= 80) return '🌟';
    if (score >= 60) return '👍';
    if (score >= 40) return '⚠️';
    return '🚨';
  }

  // Health Score Label
  static String getHealthScoreLabel(double score) {
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Good';
    if (score >= 40) return 'Average';
    return 'Critical';
  }

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
      primary: primaryColor,
      secondary: secondaryColor,
      error: errorColor,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBackground,
      cardColor: lightCard,
      dividerColor: lightDivider,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: lightSurface,
        foregroundColor: Colors.black87,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        color: lightCard,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: lightDivider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: lightDivider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 8,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        backgroundColor: lightSurface,
      ),
    );
  }

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
      primary: primaryColor,
      secondary: secondaryColor,
      error: errorColor,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      cardColor: darkCard,
      dividerColor: darkDivider,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: darkSurface,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        color: darkCard,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: darkDivider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: darkDivider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 8,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        backgroundColor: darkSurface,
      ),
    );
  }
}
