import 'package:flutter/material.dart';
import 'package:my_daily_expense/controller/expense_category_controller.dart';
import 'package:my_daily_expense/controller/expense_controller.dart';
import 'package:my_daily_expense/controller/theme_controller.dart';
import 'package:my_daily_expense/controller/user_controller.dart';
import 'package:my_daily_expense/core/routing/app_router.dart';
import 'package:my_daily_expense/repository/category_repository.dart';
import 'package:my_daily_expense/repository/expense_repository.dart';
import 'package:my_daily_expense/core/theme/app_themes.dart';
import 'package:my_daily_expense/repository/user_repository.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ExpenseRepository>(create: (_) => ExpenseRepository()),
        Provider<CategoryRepository>(create: (_) => CategoryRepository()),
        Provider<UserRepository>(create: (_) => UserRepository()),
        ChangeNotifierProvider<ThemeController>(
          create: (context) => ThemeController(),
        ),
        ChangeNotifierProvider<ExpenseCategoryController>(
          create: (context) =>
              ExpenseCategoryController(context.read<CategoryRepository>()),
        ),
        ChangeNotifierProvider<ExpenseController>(
          create: (context) =>
              ExpenseController(context.read<ExpenseRepository>()),
        ),
        ChangeNotifierProvider<UserController>(
          create: (context) => UserController(context.read<UserRepository>()),
        ),
      ],
      child: Consumer<ThemeController>(
        builder: (context, themeController, child) {
          return MaterialApp.router(
            title: 'My Daily Expense',
            debugShowCheckedModeBanner: false,
            themeMode: themeController.themeMode,
            theme: AppThemes.light.themeData,
            darkTheme: AppThemes.dark.themeData,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
