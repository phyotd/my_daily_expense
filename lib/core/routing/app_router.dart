import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_daily_expense/screens/cateogry/category_list_screen.dart';
import 'package:my_daily_expense/screens/cateogry/create_category_screen.dart';
import 'package:my_daily_expense/screens/home_screen.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',

    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),

      GoRoute(
        path: '/categories',
        builder: (context, state) => const CategoryListScreen(),
      ),

      GoRoute(
        path: '/categories/create',
        builder: (context, state) => const CreateCategoryScreen(),
      ),

       GoRoute(
        path: '/settings',
        builder: (context, state) => const CreateCategoryScreen(),
      ),

      // GoRoute(
      //   path: '/categories/edit/:id',
      //   builder: (context, state) {
      //     final id = state.pathParameters['id']!;
      //     return EditCategoryPage(categoryId: id);
      //   },
      // ),
    ],

    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found'),
      ),
    ),
  );
}