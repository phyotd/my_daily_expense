import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_daily_expense/model/expense_model.dart';
import 'package:my_daily_expense/repository/expense_repository.dart';

class ExpenseController extends ChangeNotifier {
  final ExpenseRepository repository;

  ExpenseController(this.repository);

  List<ExpenseModel> expenses = [];
  StreamSubscription? _subscription;

  void startListening() {
    _subscription = repository.watchExpenses().listen((data) {
      expenses = data;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
