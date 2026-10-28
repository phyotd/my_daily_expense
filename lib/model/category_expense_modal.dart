class CategoryExpenseModal {
  final String categoryId;
  final String categoryName;
  final String categoryIcon;
  final int categoryColor;
  final double totalExpense;

  CategoryExpenseModal({
    required this.categoryId,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryColor,
    required this.totalExpense,
  });

  factory CategoryExpenseModal.fromMap(Map<String, Object?> map) {
    return CategoryExpenseModal(
      categoryId: map['category_id'] as String,
      categoryName: map['category_name'] as String,
      categoryIcon: map['category_icon'] as String? ?? 'category',
      categoryColor: (map['category_color'] as num?)?.toInt() ?? 0xFF9E9E9E,
      totalExpense: (map['total_expense'] as num).toDouble(),
    );
  }
}
