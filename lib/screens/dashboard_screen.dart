import 'package:flutter/material.dart';

import '../services/expense_service.dart';
import '../services/budget_service.dart';
import '../services/notification_service.dart';

import '../models/expense_model.dart';
import '../utils/expense_utils.dart';
import '../utils/category_style.dart';

import '../ai/ai_insights.dart';

import '../widgets/summary_card.dart';
import '../widgets/category_pie_chart.dart';
import '../widgets/ai_insights_card.dart';

import 'budget_screen.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final ExpenseService _expenseService = ExpenseService();
  final BudgetService _budgetService = BudgetService();

  // ✅ Prevent notification spam
  static bool _alertSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_balance_wallet),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BudgetScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Expense>>(
        stream: _expenseService.getExpenses(),
        builder: (context, expenseSnapshot) {
          if (!expenseSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final expenses = expenseSnapshot.data!;

          // ✅ Empty state UX
          if (expenses.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 60, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    "No expenses yet",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // ✅ Sort latest first
          expenses.sort((a, b) => b.date.compareTo(a.date));

          final total = totalExpenses(expenses);
          final categoryData = categoryTotals(expenses);

          // 🤖 AI logic
          final prediction = AIInsights.predictNextMonth(expenses);
          final tips = AIInsights.generateTips(expenses);
          final unusualExpenses = AIInsights.detectUnusual(expenses);

          return StreamBuilder<Map<String, double>>(
            stream: _budgetService.getBudgets(),
            builder: (context, budgetSnapshot) {
              final budgets = budgetSnapshot.data ?? {};
              final overspendAlerts =
                  checkOverspending(budgets, categoryData);

              // 🔔 Safe notification trigger
              if (overspendAlerts.isNotEmpty && !_alertSent) {
                _alertSent = true;
                NotificationService.showNotification(
                  "Budget Alert 🚨",
                  overspendAlerts.join(", "),
                );
              }

              if (overspendAlerts.isEmpty) {
                _alertSent = false;
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 💰 Total Summary
                    SummaryCard(amount: total),
                    const SizedBox(height: 16),

                    // 🤖 AI Insights
                    AIInsightsCard(
                      prediction: prediction,
                      tips: tips,
                    ),

                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),

                    // 🚨 Budget Alerts
                    if (overspendAlerts.isNotEmpty)
                      Card(
                        color: Colors.red.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: overspendAlerts
                                .map(
                                  (a) => Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Text(
                                      "⚠ $a",
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),

                    if (overspendAlerts.isNotEmpty)
                      const SizedBox(height: 16),

                    // ⚠ Unusual Expenses
                    if (unusualExpenses.isNotEmpty)
                      Card(
                        color: Colors.orange.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Unusual Expenses ⚠",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ...unusualExpenses.map(
                                (e) => Text(
                                  "• ₹${e.amount} on ${e.category}",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),

                    // 📊 Pie Chart
                    if (categoryData.isNotEmpty)
                      CategoryPieChart(data: categoryData),

                    const SizedBox(height: 20),

                    // 📄 Expense List
                    const Text(
                      "Recent Expenses",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: expenses.length,
                      itemBuilder: (context, index) {
                        final e = expenses[index];
                        final color = CategoryStyle.colors[e.category] ??
                            Colors.grey;
                        final icon = CategoryStyle.icons[e.category] ??
                            Icons.category;

                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: color,
                              child: Icon(icon, color: Colors.white),
                            ),
                            title: Text(
                              e.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(e.category),
                            trailing: Text(
                              "₹${e.amount}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
