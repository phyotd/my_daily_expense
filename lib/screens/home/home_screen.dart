// ignore_for_file: deprecated_member_use

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:my_daily_expense/controller/expense_controller.dart';
import 'package:my_daily_expense/controller/expense_category_controller.dart';
import 'package:my_daily_expense/controller/user_controller.dart';
import 'package:my_daily_expense/core/routing/app_routes.dart';
import 'package:my_daily_expense/helper/app_icon.dart';
import 'package:my_daily_expense/repository/expense_repository.dart';
import 'package:my_daily_expense/util/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:my_daily_expense/core/theme/theme_extensions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.onViewAllTransactions});

  final VoidCallback? onViewAllTransactions;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool visibility = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserController>().startListening();
      context.read<ExpenseController>().startListening();
      context.read<ExpenseCategoryController>().startListening();
      Future.wait([
        ExpenseRepository.instance.getCurrentMonthSummary(),
        ExpenseRepository.instance.getTotalSummary(),
        ExpenseRepository.instance.calculateExpenseByCategory(),
      ]);
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: context.appTheme.appBarTheme.backgroundColor,
        child: SingleChildScrollView(
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
                child: buildWalletBalanceCard(),
              ),
              sizeBox20(),
              buildMonthOverview(),
              sizeBox20(),

              buildExpenseBreakdown(),
              buildRecentTransaction(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.createExpense),
        icon: const Icon(Icons.add),
        label: const Text('Add transaction'),
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
              fontSize: 16,
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
                child: StreamBuilder(
                  stream: ExpenseRepository.instance.monthlySummaryStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (snapshot.data == null) {
                      return Center(child: Text('Error: No data available'));
                    }

                    final data = snapshot.data;
                    print(
                      'Summary data: $data',
                    ); // Debug print to check the data
                    return customCard(
                      'Income',
                      data?['income']?.toString() ?? '0',
                      Icons.north_east,
                      Colors.green,
                    );
                  },
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
                child: StreamBuilder(
                  stream: ExpenseRepository.instance.monthlySummaryStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    final data = snapshot.data;
                    return customCard(
                      'Expense',
                      data?['expense']?.toString() ?? '0',
                      Icons.south_east,
                      Colors.red,
                    );
                  },
                ),
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
        StreamBuilder(
          stream: ExpenseRepository.instance.totalExpenseByCategoryStream,
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (asyncSnapshot.hasError) {
              return Center(child: Text('Error: ${asyncSnapshot.error}'));
            }
            final data = asyncSnapshot.data;
            if (data == null) {
              return Center(child: Text('No data available'));
            }

            var pieChartData = data.map((item) {
              return PieChartSectionData(
                color: Color(item.categoryColor),
                title: item.totalExpense.toString(),
                value: item.totalExpense,
                titleStyle: TextStyle(
                  color: context.appTheme.textTheme.titleMedium?.color,
                ),
              );
            }).toList();
            return Row(
              children: [
                Expanded(
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: PieChart(
                      curve: Curves.ease,
                      PieChartData(sections: pieChartData),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...data.where((i) => i.totalExpense > 0).map((e) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  color: Color(e.categoryColor),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: SizedBox(
                                    width: 100,
                                    child: Text(
                                      '${e.categoryName}:',
                                      style: TextStyle(),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text('\$${e.totalExpense}'),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget customCard(String title, String value, IconData icon, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
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
                "\$$value",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: context.appTheme.textTheme.titleMedium?.color,
                ),
              ),
              Icon(icon, color: color, size: 25),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildWalletBalanceCard() {
    return StreamBuilder(
      stream: ExpenseRepository.instance.totalSummaryStream,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (asyncSnapshot.hasError) {
          return Center(child: Text('Error: ${asyncSnapshot.error}'));
        }

        if (asyncSnapshot.data == null) {
          return Center(child: Text('Error: No data available'));
        }

        final data = asyncSnapshot.data;
        print('total balance: ${data!['income']}');

        final totalIncome = (data['income'] as num).toDouble();
        final totalExpense = (data['expense'] as num).toDouble();
        final totalBalance = totalIncome - totalExpense;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Total Balance',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        visibility = !visibility;
                      });
                    },
                    child: Icon(
                      visibility ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    visibility
                        ? '\$${totalBalance.toStringAsFixed(2)}'
                        : '\$******',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '+${data['income'] ?? 0} vs last month', // compare total balance with previous month balance
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
                  widget.onViewAllTransactions?.call();
                },
                child: Text(
                  'View All',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 14,
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
              itemCount: transactions.length > fixedCount ? fixedCount : transactions.length,
              separatorBuilder: (_, __) =>
                  Divider(color: context.appTheme.themeData.dividerColor),
              itemBuilder: (context, index) {
                final expense = transactions[index];

                return Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(expense.category?.color ?? 0),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: AppIcons.icons[expense.category?.iconName] != null
                          ? Icon(
                              AppIcons.icons[expense.category?.iconName],
                              color: Colors.white,
                            )
                          : const Icon(Icons.category, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Text(
                            expense.note == ''
                                ? expense.category?.name ?? ''
                                : expense.note,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          expense.category?.name ?? "",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        expense.isExpense
                            ? Text(
                                '-\$${expense.amount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              )
                            : Text(
                                '+\$${expense.amount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                        const SizedBox(width: 8),
                        Text(
                          expense.createdAt != null
                              ? formatDateLabel(expense.expenseDate!)
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
