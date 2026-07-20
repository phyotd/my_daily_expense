import 'package:my_daily_expense/model/expense_category.dart';

class ExpenseModel {
  final String id;
  final String title;
  final double amount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ExpenseCategory category;

  ExpenseModel({
    required this.id,
    required this.title,
    required this.amount,
     this.createdAt,
    required this.category,
     this.updatedAt,
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
      'title': title,
      'amount': amount,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'category': category.toJson(),
    };
  }

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'],
      title: json['title'],
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      category: ExpenseCategory.fromJson(json['category']),
    );
  }
}
