import 'package:flutter/material.dart';
import 'package:my_daily_expense/controller/theme_controller.dart';
import 'package:my_daily_expense/core/theme/app_theme.dart';
import 'package:my_daily_expense/core/theme/app_themes.dart';
import 'package:provider/provider.dart';

extension AppThemeExtension on BuildContext {
  AppTheme get appTheme {
    return watch<ThemeController>().isDarkMode
        ? AppThemes.dark
        : AppThemes.light;
  }
}
