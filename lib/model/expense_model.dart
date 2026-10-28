import 'package:my_daily_expense/model/expense_category.dart';

class ExpenseModel {
  final String id;
  final String note;
  final double amount;
  final String categoryId;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final DateTime? expenseDate;
  final ExpenseCategory? category;
  final bool isSynced;
  final bool isExpense;

  ExpenseModel({
    required this.id,
    required this.note,
    required this.amount,
    this.createdAt,
    this.category,
    this.updatedAt,
    this.expenseDate,
    this.isSynced = false,
    required this.categoryId,
    required this.isExpense,
  });

  @override
  int get hashCode => id.hashCode;

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExpenseModel && other.id == id;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'note': note,
      'amount': amount,
      'category_id': categoryId,
      'expense_date': expenseDate?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'is_synced': isSynced ? 1 : 0,
      'is_expense': isExpense ? 1 : 0,
    };
  }

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    print("ExpenseModel.fromJson: $json");
    ExpenseCategory? category;
    if (json['category_id'] != null) {
      print("Warning: ExpenseModel.fromJson: category is null");
      category = ExpenseCategory(
        id: json['category_id'],
        name: json['category_name'],
        iconName: json['icon_name'],
        color: json['category_color'],
        isSynced: false,
      );
    }

    return ExpenseModel(
      id: json['id'],
      note: json['note'],
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      expenseDate: json['expense_date'] != null
          ? DateTime.parse(json['expense_date'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      category: category,
      categoryId: json['category_id'],
      isExpense: json['is_expense'] == 1 ? true : false,
    );
  }

  @override
  String toString() {
    return 'ExpenseModel{id: $id, note: $note, amount: $amount, categoryId: $categoryId, createdAt: $createdAt, updatedAt: $updatedAt, expenseDate: $expenseDate, isSynced: $isSynced, isExpense: $isExpense}';
  }
}
