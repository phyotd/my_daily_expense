import 'package:flutter/material.dart';
import 'package:my_daily_expense/core/theme/app_theme.dart';

class AppThemes {
  AppThemes._();

  static final light = AppTheme(
    themeData: ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.deepPurple,
      scaffoldBackgroundColor: Colors.white,

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        surfaceTintColor: Colors.white,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: Colors.black),
        titleMedium: TextStyle(color: Colors.black),
      ),
      cardColor: Colors.deepPurple,
      dividerColor: Colors.grey.shade300,
    ),

    successColor: Colors.green,
    warningColor: Colors.orange,
    dangerColor: Colors.red,
  );

  static final dark = AppTheme(
    themeData: ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.deepPurple,
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: Colors.white),
        titleMedium: TextStyle(color: Colors.white),
      ),
      cardColor: Colors.deepPurple,
      cardTheme: CardThemeData(
        color: Colors.deepPurple,
        margin: const EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      dividerColor: Colors.grey.shade900,
    ),

    successColor: Colors.greenAccent,
    warningColor: Colors.orangeAccent,
    dangerColor: Colors.redAccent,
  );
}
