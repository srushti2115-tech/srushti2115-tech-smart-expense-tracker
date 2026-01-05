import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../utils/category_style.dart';

class CategoryPieChart extends StatelessWidget {
  final Map<String, double> data;

  const CategoryPieChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: Card(
        key: ValueKey(data.length),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                "Expense Breakdown",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 220,
                child: PieChart(
                  PieChartData(
                    centerSpaceRadius: 50,
                    sectionsSpace: 4,
                    sections: data.entries.map((e) {
                      return PieChartSectionData(
                        value: e.value,
                        color:
                            CategoryStyle.colors[e.key] ?? Colors.grey,
                        radius: 60,
                        title: "${e.key}\n₹${e.value.toInt()}",
                        titleStyle: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
