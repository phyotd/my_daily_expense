// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:my_daily_expense/components/transaction_row_item.dart';
import 'package:my_daily_expense/controller/expense_controller.dart';
import 'package:my_daily_expense/screens/category_screen.dart';
import 'package:my_daily_expense/screens/expense_screen.dart';
import 'package:my_daily_expense/util/utils.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text('Welcome to My Daily Expense'),
        centerTitle: true,
        backgroundColor: Colors.white,
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
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('Categories'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CategoryScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.compare_arrows),
              title: const Text('Recent Transactions'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExpenseScreen()),
                );
              },
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          recentTransactionList(),
          const SizedBox(height: 20),
        ],
      ),
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
            borderRadius: BorderRadius.circular(24),
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
                  const Text(
                    'Recent Transactions',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ExpenseScreen()),
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

                  return TransactionRowItem(expense: expense,);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
