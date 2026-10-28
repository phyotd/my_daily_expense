import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_daily_expense/controller/expense_category_controller.dart';
import 'package:my_daily_expense/core/theme/theme_extensions.dart';
import 'package:my_daily_expense/helper/app_icon.dart';
import 'package:my_daily_expense/model/expense_category.dart';
import 'package:my_daily_expense/model/expense_model.dart';
import 'package:my_daily_expense/repository/expense_repository.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CreateExpenseScreen extends StatefulWidget {
  const CreateExpenseScreen({super.key});

  @override
  State<CreateExpenseScreen> createState() => _CreateExpenseScreenState();
}

class _CreateExpenseScreenState extends State<CreateExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  ExpenseCategory? selectedCategory;
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  bool isExpense = true;
  DateTime? expenseDate;

  @override
  void initState() {
    super.initState();
    expenseDate = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<ExpenseCategoryController>().startListening();
    });
  }

  Future<void> _createExpense() async {
    if (!(_formKey.currentState!.validate() && selectedCategory != null)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    final expense = ExpenseModel(
      id: Uuid().v4(),
      note: _notesController.text.trim(),
      categoryId: selectedCategory!.id,
      category: selectedCategory!,
      amount: double.tryParse(_amountController.text.trim()) ?? 0.0,
      expenseDate: expenseDate ?? DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isSynced: false,
      isExpense: isExpense,
    );
    debugPrint("Creating expense: ${expense.toString()}");
    try {
      await ExpenseRepository.instance.addExpense(expense);
      if (mounted) GoRouter.of(context).pop();
    } catch (e) {
      debugPrint('Error creating category: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to save transaction')),
        );
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Expense')),
      body: Container(
        color: context.appTheme.appBarTheme.backgroundColor,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Amount',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        '\$',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: const InputDecoration(
                            hintText: '0.00',
                            labelStyle: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _amountController.text = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _rowDivider(),
                  const SizedBox(height: 10),

                  Text(
                    'Categories',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 10),

                  Consumer<ExpenseCategoryController>(
                    builder: (context, controller, child) {
                      final categories = controller.categories;
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: categories.map((category) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedCategory = category;
                                  });
                                },
                                child: Chip(
                                  avatar: Icon(
                                    AppIcons.icons[category.iconName],
                                    color: selectedCategory == category
                                        ? Colors.white
                                        : Color(category.color ?? 0),
                                  ),
                                  label: Text(
                                    category.name,
                                    style: TextStyle(
                                      color: selectedCategory == category
                                          ? Colors.white
                                          : null,
                                    ),
                                  ),
                                  backgroundColor: selectedCategory == category
                                      ? context.appTheme.primaryColor
                                      : null,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  _rowDivider(),
                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Expense',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                      Switch(
                        value: isExpense,
                        onChanged: (value) {
                          setState(() {
                            isExpense = value;
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  _rowDivider(),
                  const SizedBox(height: 10),

                  const Text(
                    'Date',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: expenseDate != null
                          ? '${expenseDate!.day}/${expenseDate!.month}/${expenseDate!.year}'
                          : '',
                    ),
                    onTap: () async {
                      final now = DateTime.now();
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: expenseDate ?? now,
                        firstDate: DateTime(now.year, 1, 1),
                        lastDate: now,
                      );
                      if (selectedDate != null) {
                        setState(() {
                          expenseDate = selectedDate;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Select a date',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  _rowDivider(),
                  const SizedBox(height: 10),

                  const Text(
                    'Note (Optional)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    maxLines: 3,
                    controller: _notesController,
                    onChanged: (value) {
                      setState(() {
                        _notesController.text = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      hintText: 'Add any notes here...',
                    ),
                  ),

                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: () {
                      _createExpense();
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: context.appTheme.primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Create Expense',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _rowDivider() {
    return Divider(color: context.appTheme.themeData.dividerColor);
  }
}
