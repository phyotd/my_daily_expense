import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._();

  AppDatabase._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();

    return _database!;
  }

  Future<void> initDatabase() async {
    _database = await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'expense_tracker.db');

    // await deleteDatabase(path);

    return openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE categories ADD COLUMN icon_name TEXT');

      await db.execute('ALTER TABLE categories DROP COLUMN icon');
      await db.execute('ALTER TABLE categories DROP COLUMN is_come');
    }
  }

  Future<void> _createDatabase(Database db, int version) async {
    var now = DateTime.now().toIso8601String();
    final categories = [
      {
        'id': 'food',
        'name': 'Food & Dining',
        'icon_name': 'restaurant',
        'color': Colors.orange.value,
        'created_at': now,
        'updated_at': now,
        'is_synced': 0,
      },
      {
        'id': 'transportation',
        'name': 'Transportation',
        'icon_name': 'directions_car',
        'color': Colors.blue.value,
        'created_at': now,
        'updated_at': now,
        'is_synced': 0,
      },
      {
        'id': 'shopping',
        'name': 'Shopping',
        'icon_name': 'shopping_bag',
        'color': Colors.pink.value,
        'created_at': now,
        'updated_at': now,
        'is_synced': 0,
      },
      {
        'id': 'bills',
        'name': 'Bills & Utilities',
        'icon_name': 'receipt_long',
        'color': Colors.red.value,
        'created_at': now,
        'updated_at': now,
        'is_synced': 0,
      },
      {
        'id': 'groceries',
        'name': 'Groceries',
        'icon_name': 'local_grocery_store',
        'color': Colors.green.value,
        'created_at': now,
        'updated_at': now,
        'is_synced': 0,
      },
      {
        'id': 'health',
        'name': 'Health',
        'icon_name': 'medical_services',
        'color': Colors.teal.value,
        'created_at': now,
        'updated_at': now,
        'is_synced': 0,
      },
      {
        'id': 'entertainment',
        'name': 'Entertainment',
        'icon_name': 'movie',
        'color': Colors.purple.value,
        'created_at': now,
        'updated_at': now,
        'is_synced': 0,
      },
      {
        'id': 'travel',
        'name': 'Travel',
        'icon_name': 'flight',
        'color': Colors.cyan.value,
        'created_at': now,
        'updated_at': now,
        'is_synced': 0,
      },
      {
        'id': 'rent',
        'name': 'Rent & Housing',
        'icon_name': 'home',
        'color': Colors.brown.value,
        'created_at': now,
        'updated_at': now,
        'is_synced': 0,
      },
      {
        'id': 'personal',
        'name': 'Personal Care',
        'icon_name': 'face',
        'color': Colors.pinkAccent.value,
        'created_at': now,
        'updated_at': now,
        'is_synced': 0,
      },
      {
        'id': 'salary',
        'name': 'Salary',
        'icon_name': 'payments',
        'color': Colors.green.value,
        'created_at': now,
        'updated_at': now,
        'is_synced': 0,
      },
      {
        'id': 'freelance',
        'name': 'Freelance',
        'icon_name': 'work',
        'color': Colors.blueGrey.value,
        'created_at': now,
        'updated_at': now,
        'is_synced': 0,
      },
      {
        'id': 'other',
        'name': 'Other',
        'icon_name': 'more_horiz',
        'color': Colors.grey.value,
        'created_at': now,
        'updated_at': now,
        'is_synced': 0,
      },
    ];
    await db.execute('''
      CREATE TABLE categories(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        icon_name TEXT,
        color INTEGER,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        is_synced INTEGER NOT NULL DEFAULT 0
      )
    ''');

    for (final category in categories) {
      await db.insert('categories', category);
    }

    await db.execute('''
      CREATE TABLE transactions(
        id TEXT PRIMARY KEY,
        note TEXT NOT NULL,
        amount DOUBLE NOT NULL DEFAULT 0,
        is_expense INTEGER NOT NULL DEFAULT 0,
        expense_date TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        is_synced INTEGER NOT NULL DEFAULT 0,
        category_id TEXT NOT NULL,
        FOREIGN KEY(category_id) REFERENCES categories(id)
      )
    ''');
  }
}
