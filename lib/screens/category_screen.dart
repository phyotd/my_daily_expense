import 'package:flutter/material.dart';
import 'package:my_daily_expense/controller/expense_category_controller.dart';
import 'package:my_daily_expense/util/utils.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Expense Categories'),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Consumer<ExpenseCategoryController>(
        builder: (context, expenseController, child) {
          final categories = expenseController.categories;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: ListTile(
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: getRandomPastelColor(), width: 1.5),
                  ),
                  leading: CircleAvatar(
                    backgroundColor: category.color.withOpacity(0.2),
                    child: Icon(category.icon, color: category.color),
                  ),
                  title: Text(
                    category.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
