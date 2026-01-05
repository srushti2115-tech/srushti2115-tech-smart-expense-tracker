import 'package:flutter/material.dart';

class AIInsightsCard extends StatelessWidget {
  final List<String> tips;
  final double prediction;

  const AIInsightsCard({
    super.key,
    required this.tips,
    required this.prediction,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "AI Insights 🤖",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Text(
              "Predicted next month expense: ₹${prediction.toStringAsFixed(0)}",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),
            ...tips.map(
              (t) => Text("• $t"),
            )
          ],
        ),
      ),
    );
  }
}
