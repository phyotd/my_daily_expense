import 'package:flutter/material.dart';
import 'package:my_daily_expense/helper/app_icon.dart';
import 'package:my_daily_expense/model/expense_model.dart';
import 'package:my_daily_expense/util/utils.dart';

class TransactionRowItem extends StatelessWidget {
  final ExpenseModel expense;
  final VoidCallback? onDelete;

  const TransactionRowItem({super.key, required this.expense, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final bool isIncome = expense.category.isExpense == false;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

      leading: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: expense.category.color?.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: AppIcons.icons[expense.category.iconName] != null
            ? Icon(
                AppIcons.icons[expense.category.iconName],
                color: expense.category.color,
              )
            : const Icon(Icons.category, color: Colors.grey),
      ),

      title: Text(
        expense.title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),

      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          dateFormatter.format(expense.createdAt?.toLocal() ?? DateTime.now()),
          style: TextStyle(color: Colors.grey.shade600),
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
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: onDelete,
            ),
          ],
        ],
      ),
    );
  }
}
