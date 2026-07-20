import 'package:flutter/material.dart';

class ExpenseCategory {
  final String id;
  final String name;
  final String? iconName;
  final Color? color;
  final bool isExpense;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ExpenseCategory({
    required this.id,
    required this.name,
    this.iconName,
    required this.color,
    required this.isExpense,
    this.createdAt,
    this.updatedAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ExpenseCategory && id == other.id;

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon_name': iconName,
      'color': color?.value,
      'is_expense': isExpense,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory ExpenseCategory.fromJson(Map<String, dynamic> json) {
    return ExpenseCategory(
      id: json['id'],
      name: json['name'],
      iconName: json['icon_name'],
      color: json['color'] != null ? Color(json['color']) : Colors.grey,
      isExpense: json['is_expense'] ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }
}
