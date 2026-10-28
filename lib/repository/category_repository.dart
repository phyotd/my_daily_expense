import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_daily_expense/database/app_database.dart';
import 'package:my_daily_expense/model/expense_category.dart';
import 'package:sqflite/sqflite.dart';

class CategoryRepository {
  // final CollectionReference _collection = FirebaseFirestore.instance.collection(
  //   'categories',
  // );

  CategoryRepository._();

  static final CategoryRepository instance = CategoryRepository._();

  final StreamController<List<ExpenseCategory>> _controller =
      StreamController<List<ExpenseCategory>>.broadcast();

  Future<Database> get _db => AppDatabase.instance.database;

  Stream<List<ExpenseCategory>> watchCategories() {
    loadCategories();
    return _controller.stream;
  }

  Future<void> loadCategories() async {
    try {
      final db = await _db;
      final rows = await db.query('categories', orderBy: 'created_at');
      print('Categories in DB: $rows');
      final categories = rows
          .map((row) => ExpenseCategory.fromJson(row))
          .toList();
      print("Loaded categories: $categories");
      _controller.add(categories);
    } catch (e) {
      print("Error loading categories: $e");
    }
  }

  // save to local database
  Future<void> addCategory(ExpenseCategory category) async {
    try {
      final db = await AppDatabase.instance.database;
      await db.insert('categories', category.toJson());
      await loadCategories();
    } catch (e) {
      print("Error adding category: $e");
    }
  }

  Future<void> updateCategory(ExpenseCategory category) async {
    try {
      final db = await AppDatabase.instance.database;
      await db.update(
        'categories',
        category.toJson(),
        where: 'id = ?',
        whereArgs: [category.id],
      );
      await loadCategories();
    } catch (e) {
      print("Error updating category: $e");
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      final db = await AppDatabase.instance.database;
      await db.delete('categories', where: 'id = ?', whereArgs: [id]);
      await loadCategories();
    } catch (e) {
      print("Error deleting category: $e");
    }
  }

  void dispose() {
    _controller.close();
  }
}
