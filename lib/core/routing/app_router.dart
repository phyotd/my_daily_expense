import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_daily_expense/screens/cateogry/category_list_screen.dart';
import 'package:my_daily_expense/screens/cateogry/create_category_screen.dart';
import 'package:my_daily_expense/screens/dashboard/dashboard_screen.dart';
import 'package:my_daily_expense/screens/transaction/create_expense_screen.dart';
import 'package:my_daily_expense/screens/transaction/transactions_screen.dart';
import 'package:my_daily_expense/screens/settings/setting_screen.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',

    routes: [
      GoRoute(path: '/', builder: (context, state) => const DashboardScreen()),

      GoRoute(
        path: '/categories',
        builder: (context, state) => const CategoryListScreen(),
      ),

      GoRoute(
        path: '/categories/create',
        builder: (context, state) => const CreateCategoryScreen(),
      ),
      GoRoute(
        path: '/expenses',
        builder: (context, state) => const TransactionsScreen(),
      ),
      GoRoute(
        path: '/expenses/create',
        builder: (context, state) => const CreateExpenseScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],

    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found'))),
  );
}
