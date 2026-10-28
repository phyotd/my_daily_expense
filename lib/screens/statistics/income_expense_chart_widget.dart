import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class IncomeExpenseChart extends StatefulWidget {
  const IncomeExpenseChart({super.key});

  @override
  State<IncomeExpenseChart> createState() => _IncomeExpenseChartState();
}

class _IncomeExpenseChartState extends State<IncomeExpenseChart> {
  bool isMonthly = true;

  final List<ChartData> monthlyData = [
    ChartData('Jan', 65000, 42000),
    ChartData('Feb', 70000, 38500),
    ChartData('Mar', 72000, 46000),
    ChartData('Apr', 68000, 41000),
    ChartData('May', 75000, 49500),
    ChartData('Jun', 80000, 42500),
  ];

  final List<ChartData> yearlyData = [
    ChartData('2023', 650000, 420000),
    ChartData('2024', 720000, 480000),
    ChartData('2025', 850000, 560000),
    ChartData('2026', 520000, 310000),
  ];
  @override
  Widget build(BuildContext context) {
    final data = isMonthly ? monthlyData : yearlyData;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            SizedBox(height: 280, child: BarChart(_buildBarChartData(data))),
            const SizedBox(height: 16),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Income vs Expense',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SegmentedButton<bool>(
          segments: const [
            ButtonSegment(value: true, label: Text('Month')),
            ButtonSegment(value: false, label: Text('Year')),
          ],
          selected: {isMonthly},
          onSelectionChanged: (value) {
            setState(() {
              isMonthly = value.first;
            });
          },
        ),
      ],
    );
  }

  BarChartData _buildBarChartData(List<ChartData> data) {
    final maxValue = data
        .expand<double>((item) => [item.income, item.expense])
        .reduce((a, b) => a > b ? a : b);
    final maxY = ((maxValue / 10000).ceil() * 10000).toDouble() + 10000;

    return BarChartData(
      maxY: maxY,
      alignment: BarChartAlignment.spaceAround,
      barTouchData: BarTouchData(enabled: true),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 45,
            interval: maxY / 5,
            getTitlesWidget: (value, meta) {
              return Text(
                '${(value / 1000).toStringAsFixed(0)}K',
                style: const TextStyle(fontSize: 11),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();

              if (index < 0 || index >= data.length) {
                return const SizedBox();
              }

              return Text(
                data[index].label.toString(),
                style: const TextStyle(fontSize: 11),
              );
            },
          ),
        ),
      ),
      gridData: const FlGridData(show: true, drawVerticalLine: false),
      borderData: FlBorderData(show: false),
      barGroups: List.generate(data.length, (index) {
        final item = data[index];

        return BarChartGroupData(
          x: index,
          barsSpace: 4,
          barRods: [
            BarChartRodData(
              toY: item.income,
              width: 8,
              color: Colors.green,
              borderRadius: BorderRadius.circular(2),
            ),
            BarChartRodData(
              toY: item.expense,
              width: 8,
              color: Colors.red,
              borderRadius: BorderRadius.circular(2),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem('Income', true),
        const SizedBox(width: 24),
        _legendItem('Expense', false),
      ],
    );
  }

  Widget _legendItem(String title, bool isIncome) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isIncome ? Colors.green : Colors.red,
          ),
        ),
        const SizedBox(width: 6),
        Text(title),
      ],
    );
  }
}

class ChartData {
  final String label;
  final double income;
  final double expense;

  ChartData(this.label, this.income, this.expense);
}
