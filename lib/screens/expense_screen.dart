import 'package:flutter/material.dart';
import 'package:my_daily_expense/components/transaction_row_item.dart';
import 'package:my_daily_expense/controller/expense_category_controller.dart';
import 'package:my_daily_expense/model/expense_category.dart';
import 'package:my_daily_expense/model/expense_model.dart';
import 'package:provider/provider.dart';
import 'package:my_daily_expense/controller/expense_controller.dart';
import 'package:uuid/uuid.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Daily Expense'),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(onPressed: () {Navigator.of(context).pop();}, icon: const Icon(Icons.arrow_back_ios_new)),
      ),
      body: Consumer<ExpenseController>(
        builder: (context, expenseController, child) {
          final expenses = expenseController.expenses;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final expense = expenses[index];
                return TransactionRowItem(
                  expense: expense,
                  onDelete: () => expenseController.removeExpense(expense),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showAddExpenseDialog(context);
        },
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,

        elevation: 4,
        label: const Text(
          'New Expense',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  void showAddExpenseDialog(BuildContext context) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    ExpenseCategory? selectedCategory;

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            
          ),

          title: const Text(
            'New Expense',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Title
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    hintText: 'Lunch, Salary...',
                    prefixIcon: const Icon(Icons.edit),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// Category
                Consumer<ExpenseCategoryController>(
                  builder: (context, categoryController, child) {
                    return DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),

                      items: categoryController.categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        selectedCategory = value;
                      },
                    );
                  },
                ),

                const SizedBox(height: 16),

                /// Amount
                TextField(
                  controller: amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    hintText: '+100 or -50',
                    prefixIcon: const Icon(Icons.attach_money),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 18,
                      color: Colors.grey.shade600,
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Text(
                        'Use + for income and - for expense',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),

          actions: [
            /// Cancel
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),

            /// Add
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                final title = titleController.text.trim();

                final amount =
                    double.tryParse(amountController.text.trim()) ?? 0;

                if (title.isEmpty) return;

                if (selectedCategory == null) return;
                ExpenseModel expense = ExpenseModel(
                  title: title,
                  amount: amount,
                  category: selectedCategory!,
                  id: Uuid().v4(),
                  date: DateTime.now(),
                  expenseAmount: amountController.text.trim().isEmpty
                      ? 0
                      : double.tryParse(amountController.text.trim()) ?? 0,
                );

                addNewExpense(context, expense);
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void addNewExpense(BuildContext context, ExpenseModel expense) {
    Provider.of<ExpenseController>(context, listen: false).addExpense(expense);
  }
}
