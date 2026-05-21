import 'package:flutter/material.dart';
import 'package:my_daily_expense/model/expense_model.dart';
import 'package:my_daily_expense/util/utils.dart';

class TransactionRowItem extends StatelessWidget {
  final ExpenseModel expense;
  final VoidCallback? onDelete;

  const TransactionRowItem({
    super.key,
    required this.expense,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = expense.amount >= 0;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),

      leading: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: expense.category.color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          expense.category.icon,
          color: expense.category.color,
        ),
      ),

      title: Text(
        expense.title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),

      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          dateFormatter.format(expense.date.toLocal()),
          style: TextStyle(
            color: Colors.grey.shade600,
          ),
        ),
      ),

      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${isIncome ? '+' : '-'}\$${formatAmount(expense.amount.abs())}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isIncome ? Colors.green : Colors.redAccent,
            ),
          ),

          if (onDelete != null) ...[
            const SizedBox(width: 8),

            IconButton(
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.redAccent,
              ),
              onPressed: onDelete,
            ),
          ],
        ],
      ),
    );
  }
}