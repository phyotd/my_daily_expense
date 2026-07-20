import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_daily_expense/helper/app_icon.dart';
import 'package:my_daily_expense/model/expense_category.dart';
import 'package:my_daily_expense/repository/category_repository.dart';
import 'package:uuid/uuid.dart';

class CreateCategoryScreen extends StatefulWidget {
  const CreateCategoryScreen({super.key});

  @override
  State<CreateCategoryScreen> createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends State<CreateCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final categoryRepository = CategoryRepository();

  String? _selectedIcon;

  bool isExpense = false;

  Future<void> _createCategory() async {
    if (_formKey.currentState!.validate()) {
      final category = ExpenseCategory(
        name: _nameController.text.trim(),
        iconName: _selectedIcon!,
        id: Uuid().v4(),
        color: null,
        isExpense: isExpense,
         createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
      );
      debugPrint(category.toString());

      try {
        await categoryRepository.addCategory(category);
        GoRouter.of(context).pop();
      } catch (e) {
        debugPrint('Error creating category: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create Category'),
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            GoRouter.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Category Name',
                    hintText: 'Enter category name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a category name';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: _selectedIcon,
                  decoration: const InputDecoration(
                    labelText: 'Select Icon',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                  items: AppIcons.icons.keys
                      .map(
                        (icon) => DropdownMenuItem(
                          alignment: Alignment.center,
                          value: icon,
                          child: Row(
                            children: [
                              Icon(AppIcons.icons[icon]),
                              const SizedBox(width: 10),
                              Text(icon),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select an icon';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _selectedIcon = value;
                    });
                  },
                ),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Expense'),
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

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _createCategory,
                    child: const Text('Create Category'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
