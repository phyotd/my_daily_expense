// ignore_for_file: deprecated_member_use

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:my_daily_expense/controller/expense_controller.dart';
import 'package:my_daily_expense/controller/theme_controller.dart';
import 'package:my_daily_expense/controller/user_controller.dart';
import 'package:my_daily_expense/helper/app_icon.dart';
import 'package:my_daily_expense/screens/cateogry/category_list_screen.dart';
import 'package:my_daily_expense/screens/expense/expense_list_screen.dart';
import 'package:my_daily_expense/util/utils.dart';
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
        title: const Text('Dashboard'),
        centerTitle: true,
        backgroundColor: context.appTheme.appBarTheme.backgroundColor,
        surfaceTintColor: context.appTheme.appBarTheme.surfaceTintColor,
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
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: context.appTheme.primaryColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [buildWalletBalanceCard()],
              ),
            ),
            sizeBox20(),
            buildMonthOverview(),
            sizeBox20(),

            buildExpenseBreakdown(),
            buildRecentTransaction(),
            // shortcutButtons(),
            // sizeBox20(),
            // recentTransactionList(),
            // sizeBox20(),
            // expensesByCategories(),
            // sizeBox20(),
          ],
        ),
      ),
      bottomNavigationBar: GNav(
        tabs: [
          GButton(
            icon: Icons.home,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
          ),
          GButton(
            icon: Icons.category,
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
            icon: Icons.add,
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ExpenseListScreen()),
              );
            },
          ),
          GButton(
            icon: Icons.settings,
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

  Widget buildSectionTitle(String title, {Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: context.appTheme.textTheme.titleMedium?.color,
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget buildMonthOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle("This month overview"),
        sizeBox10(),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: customCard(
                  'Income',
                  '0',
                  Icons.north_east,
                  Colors.green,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: customCard('Expense', '0', Icons.south_east, Colors.red),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget sizeBox20() {
    return const SizedBox(height: 20);
  }

  Widget sizeBox10() {
    return const SizedBox(height: 10);
  }

  Widget buildExpenseBreakdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle(
          "Expense Breakdown",
          trailing: Text(
            'This Month',
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: context.appTheme.textTheme.titleMedium?.color,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 200,
                child: PieChart(
                  curve: Curves.ease,
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        color: Colors.orange,
                        value: 50,
                        showTitle: false,
                        title: 'Food',
                      ),
                      PieChartSectionData(
                        color: Colors.blue,
                        value: 30,
                        showTitle: false,
                        title: 'Transport',
                      ),
                      PieChartSectionData(
                        color: Colors.purple,
                        value: 40,
                        showTitle: false,
                        title: 'Shopping',
                      ),
                      PieChartSectionData(
                        color: Colors.green,
                        value: 40,
                        showTitle: false,
                        title: 'Others',
                      ),
                      PieChartSectionData(
                        color: Colors.red,
                        value: 10,
                        showTitle: false,
                        title: 'Bills',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 30),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            color: Colors.orange,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text('Food:'),
                          ),
                        ],
                      ),
                      Text('50%'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(width: 10, height: 10, color: Colors.blue),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text('Transport:'),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text('50%'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            color: Colors.purple,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text('Shopping:'),
                          ),
                        ],
                      ),
                      Text('50%'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(width: 10, height: 10, color: Colors.red),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text('Bills:'),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text('50%'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(width: 10, height: 10, color: Colors.grey),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text('Others:'),
                          ),
                        ],
                      ),
                      Text('10%'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget customCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: context.appTheme.textTheme.titleMedium?.color,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: context.appTheme.textTheme.titleMedium?.color,
                ),
              ),
              Icon(icon, color: color, size: 35),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildWalletBalanceCard() {
    return Consumer<UserController>(
      builder: (_, userController, child) {
        final user = userController.currentUser;
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Balance',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '\$${user?.walletBalance ?? 0}',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.south_west, color: Colors.white, size: 30),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '+${user?.walletBalance ?? 0} vs last month', // compare total balance with previous month balance
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
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
                'Total Expense',
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

  Widget buildRecentTransaction() {
    return Consumer<ExpenseController>(
      builder: (context, expenseController, child) {
        final transactions = expenseController.expenses;
        return Column(
          children: [
            buildSectionTitle(
              "Recent Transactions",
              trailing: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ExpenseListScreen(),
                    ),
                  );
                },
                child: Text(
                  'See All',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: context.appTheme.primaryColor,
                  ),
                ),
              ),
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

                return Row(
                  children: [
                    Container(
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
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          expense.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          expense.category.name,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('\$${expense.amount.toStringAsFixed(2)}'),
                        const SizedBox(width: 8),
                        Text(
                          expense.createdAt != null
                              ? formatDateLabel(expense.createdAt!)
                              : "",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }
}
