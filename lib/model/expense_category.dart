import 'package:flutter/material.dart';

class ExpenseCategory {
  final String id;
  final String name;
  final IconData? icon;
  final Color color;

  ExpenseCategory({
    required this.id,
    required this.name,
    this.icon,
    required this.color,
  });

   @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseCategory &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }

  factory ExpenseCategory.fromJson(Map<String, dynamic> json) {
    return ExpenseCategory(
      id: json['id'],
      name: json['name'],
      color: json['color'] != null ? Color(json['color']) : Colors.grey,
    );
  }
}
