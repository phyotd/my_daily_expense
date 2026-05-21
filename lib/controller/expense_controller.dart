import 'package:flutter/material.dart';
import 'package:my_daily_expense/controller/base_controller.dart';
import 'package:my_daily_expense/model/expense_category.dart';
import 'package:my_daily_expense/model/expense_model.dart';

class ExpenseController extends BaseController {
  final List<ExpenseModel> _expenses = [];

  List<ExpenseModel> get expenses => _expenses;

  ExpenseController() {
    // Initialize with some dummy data
    _expenses.addAll([
      ExpenseModel(
        id: '1',
        title: 'Groceries',
        amount: -50.0,
        date: DateTime.now(),
        category: ExpenseCategory(id: '1', name: 'Food & Drink', icon: Icons.fastfood, color: Colors.orange), expenseAmount: 100,
      ),
      ExpenseModel(
        id: '2',
        title: 'Transportation',
        amount: -20.0,
        date: DateTime.now(),
        category: ExpenseCategory(id: '2', name: 'Transportation', icon: Icons.directions_car, color: Colors.blue), expenseAmount: 5,
      ),
      ExpenseModel(
        id: '3',
        title: 'Utilities',
        amount: -100.0,
        date: DateTime.now(),
        category: ExpenseCategory(id: '3', name: 'Bills', icon: Icons.receipt, color: Colors.green), expenseAmount: 30,
      ),
    ]);
  }

  void addExpense(ExpenseModel expense) {
    _expenses.add(expense);
    notifyListeners();
  }

  void removeExpense(ExpenseModel expense) {
    _expenses.remove(expense);
    notifyListeners();
  }

  double getTotalExpenses() {
    return _expenses.fold(0, (total, expense) => total + expense.amount);
  }
}
