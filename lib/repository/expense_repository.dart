import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_daily_expense/database/app_database.dart';
import 'package:my_daily_expense/model/category_expense_modal.dart';
import 'package:my_daily_expense/model/expense_model.dart';
import 'package:sqflite/sqflite.dart';

class ExpenseRepository {
  ExpenseRepository._();

  static final ExpenseRepository instance = ExpenseRepository._();

  final CollectionReference _collection = FirebaseFirestore.instance.collection(
    'expenses',
  );

  final StreamController<List<ExpenseModel>> _controller =
      StreamController<List<ExpenseModel>>.broadcast();

  final StreamController<Map<String, double>> _summaryMonthlyController =
      StreamController<Map<String, double>>.broadcast();

  Stream<Map<String, double>> get monthlySummaryStream =>
      _summaryMonthlyController.stream;

  final StreamController<Map<String, double>> _totalSummaryController =
      StreamController<Map<String, double>>.broadcast();

  Stream<Map<String, double>> get totalSummaryStream =>
      _totalSummaryController.stream;

  final StreamController<List<CategoryExpenseModal>>
  _totalExpenseByCategoryController =
      StreamController<List<CategoryExpenseModal>>.broadcast();

  Stream<List<CategoryExpenseModal>> get totalExpenseByCategoryStream =>
      _totalExpenseByCategoryController.stream;

  Future<Database> get _db => AppDatabase.instance.database;

  Stream<List<ExpenseModel>> watchExpenses() {
    loadTransactions();
    return _controller.stream;
  }

  Future<void> loadTransactions() async {
    try {
      final db = await _db;
      final sql = '''
      SELECT 
      transactions.*,
      categories.name AS category_name,
      categories.icon_name AS icon_name,
      categories.color AS category_color
      FROM transactions
      INNER JOIN categories ON transactions.category_id = categories.id
      ORDER BY transactions.expense_date DESC
      ''';
      final rows = await db.rawQuery(sql);
      debugPrint('Transactions in DB: $rows');
      final transactions = rows
          .map((row) => ExpenseModel.fromJson(row))
          .toList();
      debugPrint("Loaded transactions: $transactions");
      _controller.add(transactions);
    } catch (e) {
      debugPrint("Error loading transactions: $e");
    }
  }

  Future<void> addExpense(ExpenseModel expense) async {
    final db = await _db;
    await db.insert('transactions', expense.toJson());
    await refresh();
  }

  Future<void> updateExpense(ExpenseModel expense) async {
    final db = await _db;
    await db.update(
      'transactions',
      expense.toJson(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
    await refresh();
  }

  Future<void> deleteExpense(String id) async {
    final db = await _db;
    await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
    await refresh();
  }

  Future<void> getTotalSummary() async {
    final db = await _db;

    final result = await db.rawQuery('''
    SELECT
     COALESCE(
        SUM(CASE WHEN is_expense = 1 THEN amount ELSE 0 END),
        0
      ) AS total_expense,
      COALESCE(
        SUM(CASE WHEN is_expense = 0 THEN amount ELSE 0 END),
        0
      ) AS total_income

    FROM transactions
    ''');

    debugPrint(" total balance row: $result");
    final row = result.first;

    _totalSummaryController.add({
      'expense': (row['total_expense'] as num).toDouble(),
      'income': (row['total_income'] as num).toDouble(),
    });
  }

  Future<void> getCurrentMonthSummary() async {
    final db = await _db;

    final now = DateTime.now();

    final startOfMonth = DateTime(now.year, now.month, 1);

    final startOfNextMonth = DateTime(now.year, now.month + 1, 1);

    final result = await db.rawQuery(
      '''
    SELECT
      COALESCE(
        SUM(CASE WHEN is_expense = 1 THEN amount ELSE 0 END),
        0
      ) AS total_expense,

      COALESCE(
        SUM(CASE WHEN is_expense = 0 THEN amount ELSE 0 END),
        0
      ) AS total_income

    FROM transactions

    WHERE expense_date >= ?
      AND expense_date < ?
    ''',
      [startOfMonth.toIso8601String(), startOfNextMonth.toIso8601String()],
    );

    final row = result.first;

    _summaryMonthlyController.add({
      'expense': (row['total_expense'] as num).toDouble(),
      'income': (row['total_income'] as num).toDouble(),
    });
  }

  Future<void> calculateExpenseByCategory() async {
    final db = await _db;
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final startOfNextMonth = DateTime(now.year, now.month + 1, 1);
    final result = await db.rawQuery(
      '''
    SELECT
      categories.id AS category_id,
      categories.name AS category_name,
      categories.icon_name AS category_icon,
      categories.color AS category_color,
      SUM(transactions.amount) AS total_expense
    FROM transactions
    INNER JOIN categories ON transactions.category_id = categories.id
    WHERE transactions.is_expense = 1
      AND transactions.expense_date >= ?
      AND transactions.expense_date < ?
    GROUP BY categories.id, categories.name, categories.icon_name, categories.color
    ORDER BY total_expense DESC
  ''',
      [startOfMonth.toIso8601String(), startOfNextMonth.toIso8601String()],
    );

    final categoryExpenses = result
        .map((row) => CategoryExpenseModal.fromMap(row))
        .toList();

    _totalExpenseByCategoryController.add(categoryExpenses);
  }

  Future<void> refresh() async {
    await Future.wait([
      loadTransactions(),
      getCurrentMonthSummary(),
      getTotalSummary(),
      calculateExpenseByCategory(),
    ]);
  }
}
