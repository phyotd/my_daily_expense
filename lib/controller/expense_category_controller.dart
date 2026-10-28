import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_daily_expense/model/expense_category.dart';
import 'package:my_daily_expense/repository/category_repository.dart';

class ExpenseCategoryController extends ChangeNotifier {
  ExpenseCategoryController();

  final List<ExpenseCategory> _categories = [];

  List<ExpenseCategory> get categories => _categories;

  StreamSubscription? _subscription;

  void startListening() {
    _subscription?.cancel();
    _subscription = CategoryRepository.instance.watchCategories().listen((
      data,
    ) {
      debugPrint("Categories updated: ${data.length}");

      _categories
        ..clear()
        ..addAll(data);

      notifyListeners();
    });
  }

  Future<void> deleteCategory(String id) async {
    await CategoryRepository.instance.deleteCategory(id);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
