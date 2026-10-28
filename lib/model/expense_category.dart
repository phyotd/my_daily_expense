import 'package:flutter/material.dart';

class ExpenseCategory {
  final String id;
  final String name;
  final String? iconName;
  final int? color;
  final bool isSynced;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ExpenseCategory({
    required this.id,
    required this.name,
    this.iconName,
    required this.color,
    this.createdAt,
    this.updatedAt,
    required this.isSynced,
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
      'color': color,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'is_synced': isSynced ? 1 : 0,
    };
  }

  factory ExpenseCategory.fromJson(Map<String, dynamic> json) {
    return ExpenseCategory(
      id: json['id'],
      name: json['name'],
      iconName: json['icon_name'],
      color: json['color'] != null ? int.tryParse(json['color'].toString()) : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      isSynced: json['is_synced'] == 1 ? true : false,
    );
  }
}
