import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../services/expense_service.dart';
import '../models/expense_model.dart';
import '../utils/trend_utils.dart';

class TrendsScreen extends StatelessWidget {
  const TrendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expenseService = ExpenseService();

    return Scaffold(
      appBar: AppBar(title: const Text("Monthly Trends")),
      body: StreamBuilder<List<Expense>>(
        stream: expenseService.getExpenses(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final expenses = snapshot.data!;
          final monthlyData = calculateMonthlyTotals(expenses);

          if (monthlyData.isEmpty) {
            return const Center(
              child: Text("No data available"),
            );
          }

          final spots = monthlyData.entries.map((e) {
            return FlSpot(e.key.toDouble(), e.value);
          }).toList();

          return Padding(
            padding: const EdgeInsets.all(16),
            child: LineChart(
              LineChartData(
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        return Text("M${value.toInt()}");
                      },
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    spots: spots,
                    barWidth: 4,
                    color: Colors.green,
                    dotData: FlDotData(show: true),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
