import 'package:my_daily_expense/model/expense_category.dart';

class ExpenseModel {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final ExpenseCategory category;

  ExpenseModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
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
      'date': date.toIso8601String(),
      'category': category.toJson(),
    };
  }

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'],
      title: json['title'],
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      date: DateTime.parse(json['date']),
      category: ExpenseCategory.fromJson(json['category']),
    );
  }
}
