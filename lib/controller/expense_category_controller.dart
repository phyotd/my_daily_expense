import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_daily_expense/model/expense_category.dart';
import 'package:my_daily_expense/repository/category_repository.dart';

class ExpenseCategoryController extends ChangeNotifier {
  final CategoryRepository repository;

  ExpenseCategoryController(this.repository);

  final List<ExpenseCategory> _categories = [];

  List<ExpenseCategory> get categories => _categories;

  StreamSubscription? _subscription;

  void startListening() {
    _subscription = repository.watchCategories().listen((data) {
      _categories.clear();
      _categories.addAll(data);
      notifyListeners();
    });
  }

  // ExpenseCategoryController() {
  //   // Initialize with some default categories
  //   // _categories.addAll([
  //   //   ExpenseCategory(
  //   //     name: 'Food & Drink',
  //   //     id: '1',
  //   //     icon: Icons.fastfood,
  //   //     color: Colors.orange,
  //   //   ),
  //   //   ExpenseCategory(
  //   //     name: 'Transportation',
  //   //     id: '2',
  //   //     icon: Icons.directions_car,
  //   //     color: Colors.lightBlueAccent,
  //   //   ),
  //   //   ExpenseCategory(
  //   //     name: 'Bills',
  //   //     id: '3',
  //   //     icon: Icons.receipt,
  //   //     color: Colors.green,
  //   //   ),
  //   //   ExpenseCategory(
  //   //     name: 'Entertainment',
  //   //     id: '4',
  //   //     icon: Icons.movie,
  //   //     color: Colors.purple,
  //   //   ),
  //   //   ExpenseCategory(
  //   //     name: 'Health',
  //   //     id: '5',
  //   //     icon: Icons.health_and_safety,
  //   //     color: Colors.red,
  //   //   ),
  //   //   ExpenseCategory(
  //   //     name: 'Education',
  //   //     id: '6',
  //   //     icon: Icons.school,
  //   //     color: Colors.yellow,
  //   //   ),
  //   //   ExpenseCategory(
  //   //     name: 'Income',
  //   //     id: '7',
  //   //     icon: Icons.south_west,
  //   //     color: Colors.blue,
  //   //   ),
  //   // ]);

  // }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
