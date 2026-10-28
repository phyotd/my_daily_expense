import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_daily_expense/controller/expense_category_controller.dart';
import 'package:my_daily_expense/core/routing/app_routes.dart';
import 'package:my_daily_expense/helper/app_icon.dart';
import 'package:my_daily_expense/repository/category_repository.dart';
import 'package:provider/provider.dart';
import 'package:my_daily_expense/core/theme/theme_extensions.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  bool enableDelete = false;

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
          !enableDelete
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      enableDelete = !enableDelete;
                    });
                  },
                  icon: const Icon(Icons.delete),
                )
              : TextButton(
                  onPressed: () {
                    setState(() {
                      enableDelete = !enableDelete;
                    });
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: context.appTheme.textTheme.titleMedium?.color,
                    ),
                  ),
                ),
        ],
      ),
      body: Container(
        color: context.appTheme.appBarTheme.backgroundColor,
        child: StreamBuilder(
          stream: CategoryRepository.instance.watchCategories(),
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

            return GridView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Color(category.color ?? 0),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            AppIcons.icons[category.iconName],
                            color: Color(category.color ?? 0),
                            size: 30,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            category.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color:
                                  context.appTheme.textTheme.titleMedium?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    enableDelete
                        ? Positioned(
                            right: -5,
                            top: -5,
                            child: IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Delete Category'),
                                      content: Text(
                                        'Are you sure you want to delete this category?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            context
                                                .read<
                                                  ExpenseCategoryController
                                                >()
                                                .deleteCategory(category.id);
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Delete'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.clear,
                                color: Colors.red,
                                size: 20,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
