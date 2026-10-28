import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:my_daily_expense/model/category_expense_modal.dart';
import 'package:my_daily_expense/repository/expense_repository.dart';

class ExpenseStatisticsScreen extends StatelessWidget {
  const ExpenseStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = ExpenseRepository.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Statistics'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'This month',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          StreamBuilder<Map<String, double>>(
            stream: repository.monthlySummaryStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return _ErrorMessage(message: '${snapshot.error}');
              }
              if (!snapshot.hasData) return const _LoadingCard();
              final data = snapshot.data!;
              final income = data['income'] ?? 0;
              final expenses = data['expense'] ?? 0;
              return Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      title: 'Income',
                      amount: income,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _SummaryCard(
                      title: 'Expenses',
                      amount: expenses,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _SummaryCard(
                      title: 'Net',
                      amount: income - expenses,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Spending by category',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          StreamBuilder<List<CategoryExpenseModal>>(
            stream: repository.totalExpenseByCategoryStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return _ErrorMessage(message: '${snapshot.error}');
              }
              if (!snapshot.hasData) return const _LoadingCard();

              final categories = snapshot.data!
                  .where((item) => item.totalExpense > 0)
                  .toList();
              if (categories.isEmpty) {
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                      child: Text('No expenses recorded this month'),
                    ),
                  ),
                );
              }

              final total = categories.fold<double>(
                0,
                (sum, item) => sum + item.totalExpense,
              );
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 210,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 42,
                            sections: categories.map((item) {
                              final percent = item.totalExpense / total * 100;
                              return PieChartSectionData(
                                color: Color(item.categoryColor),
                                value: item.totalExpense,
                                title: '${percent.toStringAsFixed(0)}%',
                                radius: 68,
                                titleStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...categories.map((item) {
                        final percent = item.totalExpense / total * 100;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Color(item.categoryColor),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(child: Text(item.categoryName)),
                              Text('${percent.toStringAsFixed(1)}%'),
                              const SizedBox(width: 12),
                              Text('\$${item.totalExpense.toStringAsFixed(2)}'),
                            ],
                          ),
                        );
                      }),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total spending',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '\$${total.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.amount,
    required this.color,
  });

  final String title;
  final double amount;
  final Color color;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              '\$${amount.toStringAsFixed(2)}',
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    ),
  );
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) => const Card(
    child: Padding(
      padding: EdgeInsets.all(24),
      child: Center(child: CircularProgressIndicator()),
    ),
  );
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Text('Unable to load statistics: $message'),
    ),
  );
}
