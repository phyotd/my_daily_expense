import 'package:flutter/material.dart';
import 'package:my_daily_expense/controller/base_controller.dart';
import 'package:my_daily_expense/model/expense_category.dart';

class ExpenseCategoryController extends BaseController {
  final List<ExpenseCategory> _categories = [];

  List<ExpenseCategory> get categories => _categories;

  ExpenseCategoryController() {
    // Initialize with some default categories
    _categories.addAll([
      
      ExpenseCategory(
        name: 'Food & Drink',
        id: '1',
        icon: Icons.fastfood,
        color: Colors.orange,
      ),
      ExpenseCategory(
        name: 'Transportation',
        id: '2',
        icon: Icons.directions_car,
        color: Colors.lightBlueAccent,
      ),
      ExpenseCategory(
        name: 'Bills',
        id: '3',
        icon: Icons.receipt,
        color: Colors.green,
      ),
      ExpenseCategory(
        name: 'Entertainment',
        id: '4',
        icon: Icons.movie,
        color: Colors.purple,
      ),
      ExpenseCategory(
        name: 'Health',
        id: '5',
        icon: Icons.health_and_safety,
        color: Colors.red,
      ),
      ExpenseCategory(
        name: 'Education',
        id: '6',
        icon: Icons.school,
        color: Colors.yellow,
      ),
      ExpenseCategory(
        name: 'Income',
        id: '7',
        icon: Icons.south_west,
        color: Colors.blue,
      ),
    ]);
  }

  void addCategory(ExpenseCategory category) {
    _categories.add(category);
    notifyListeners();
  }

  void removeCategory(ExpenseCategory category) {
    _categories.remove(category);
    notifyListeners();
  }
}
