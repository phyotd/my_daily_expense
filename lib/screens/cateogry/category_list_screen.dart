import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_daily_expense/controller/expense_category_controller.dart';
import 'package:my_daily_expense/core/routing/app_routes.dart';
import 'package:my_daily_expense/helper/app_icon.dart';
import 'package:my_daily_expense/repository/category_repository.dart';
import 'package:my_daily_expense/core/theme/app_theme.dart';
import 'package:my_daily_expense/util/utils.dart';
import 'package:provider/provider.dart';
import 'package:my_daily_expense/core/theme/theme_extensions.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  final categoryRepository = CategoryRepository();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExpenseCategoryController>().startListening();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Expense Categories'),
        centerTitle: true,
        backgroundColor: context.appTheme.appBarTheme.backgroundColor,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.push(AppRoutes.createCategory);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: categoryRepository.watchCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No category found'));
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final categories = snapshot.data ?? [];
        
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              Color randomColor = getRandomPastelColor();
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: ListTile(
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: randomColor, width: 1.5),
                  ),
                  leading: CircleAvatar(
                    backgroundColor: category.color?.withOpacity(0.1),
                    child: Icon(
                      AppIcons.icons[category.iconName],
                      color: randomColor,
                    ),
                  ),
                  title: Text(
                    category.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: context.appTheme.textTheme.titleMedium?.color,
                    ),
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
