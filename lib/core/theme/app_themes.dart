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
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: Colors.black),
        titleMedium: TextStyle(color: Colors.black),
      ),
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
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: Colors.black),
        titleMedium: TextStyle(color: Colors.black),
      ),
    ),

    successColor: Colors.greenAccent,
    warningColor: Colors.orangeAccent,
    dangerColor: Colors.redAccent,
  );
}
