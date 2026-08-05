import 'package:flutter/material.dart';

class AppTheme {
  final ThemeData themeData;

  final Color successColor;
  final Color warningColor;
  final Color dangerColor;

  const AppTheme({
    required this.themeData,
    required this.successColor,
    required this.warningColor,
    required this.dangerColor,
  });

  Color get scaffoldBackgroundColor => themeData.scaffoldBackgroundColor;

  Color get primaryColor => themeData.primaryColor;

  AppBarThemeData get appBarTheme => themeData.appBarTheme;

  TextTheme get textTheme => themeData.textTheme;

  Color get cardColor => themeData.cardColor;
}
