// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:my_daily_expense/components/transaction_row_item.dart';
import 'package:my_daily_expense/controller/expense_controller.dart';
import 'package:my_daily_expense/controller/theme_controller.dart';
import 'package:my_daily_expense/controller/user_controller.dart';
import 'package:my_daily_expense/screens/cateogry/category_list_screen.dart';
import 'package:my_daily_expense/screens/expense/expense_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:my_daily_expense/core/theme/theme_extensions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserController>().startListening();
      context.read<ExpenseController>().startListening();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Welcome to My Daily Expense'),
        centerTitle: true,
        backgroundColor: context.appTheme.appBarTheme.backgroundColor,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Text(
                'My Daily Expense',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('Categories'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CategoryListScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.compare_arrows),
              title: const Text('Recent Transactions'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExpenseListScreen()),
                );
              },
            ),
            ListTile(
              leading: context.watch<ThemeController>().isDarkMode
                  ? const Icon(Icons.light_mode)
                  : const Icon(Icons.dark_mode),
              title: const Text('Dark Mode'),
              onTap: () {
                // Toggle dark mode
                final themeController = context.read<ThemeController>();
                themeController.toggleTheme();
              },
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [buildWalletBalanceCard(), buildExpenseBalanceCard()],
            ),
            sizeBox20(),
            shortcutButtons(),
            // sizeBox20(),
            recentTransactionList(),
            // sizeBox20(),
            expensesByCategories(),
            sizeBox20(),
          ],
        ),
      ),
      bottomNavigationBar: GNav(
        tabs: [
          GButton(
            icon: Icons.home,
            text: 'Home',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
          ),
          GButton(
            icon: Icons.category,
            text: 'Categories',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CategoryListScreen(),
                ),
              );
            },
          ),
          GButton(
            icon: Icons.compare_arrows,
            text: 'Recent Transactions',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ExpenseListScreen()),
              );
            },
          ),
          GButton(
            icon: Icons.settings,
            text: 'Settings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ExpenseListScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget sizeBox20() {
    return const SizedBox(height: 20);
  }

  Widget buildWalletBalanceCard() {
    return Consumer<UserController>(
      builder: (context, userController, child) {
        final user = userController.currentUser;
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Wallet Balance',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                '\$${user?.walletBalance ?? 0}',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: context.appTheme.primaryColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildExpenseBalanceCard() {
    return Consumer<UserController>(
      builder: (context, userController, child) {
        final user = userController.currentUser;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Expense Balance',
                textAlign: TextAlign.end,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                '-\$${user?.expenseBalance ?? 0}',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget shortcutButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          flex: 1,
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.transparent,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: context.appTheme.primaryColor,
                    width: 1,
                  ),
                ),
              ),
              onPressed: () {
                // Navigate to Add Expense Screen
              },
              child: const Text('+ Expense'),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                // Navigate to Reports Screen
              },
              child: const Text('+ Income'),
            ),
          ),
        ),
      ],
    );
  }

  Widget recentTransactionList() {
    return Consumer<ExpenseController>(
      builder: (context, expenseController, child) {
        final transactions = expenseController.expenses;
        return Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Transactions',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: context.appTheme.textTheme.titleMedium?.color,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ExpenseListScreen(),
                        ),
                      );
                    },
                    child: const Row(
                      children: [
                        Text('See All'),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios, size: 14),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transactions.length,
                separatorBuilder: (_, __) => Divider(color: Colors.grey[100]),
                itemBuilder: (context, index) {
                  final expense = transactions[index];

                  // return TransactionRowItem(expense: expense);
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(expense.title),
                      const SizedBox(width: 8),
                      Text('\$${expense.amount.toStringAsFixed(2)}'),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget expensesByCategories() {
    return Consumer<ExpenseController>(
      builder: (context, expenseController, child) {
        final transactions = expenseController.expenses;
        return Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Expense by Categories',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: context.appTheme.textTheme.titleMedium?.color,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ExpenseListScreen(),
                        ),
                      );
                    },
                    child: const Row(
                      children: [
                        Text('See All'),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios, size: 14),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transactions.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final expense = transactions[index];

                  return TransactionRowItem(expense: expense);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
