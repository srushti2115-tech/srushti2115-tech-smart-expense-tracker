import '../models/expense_model.dart';

class AIInsights {
  /// Monthly total prediction (simple moving average)
  static double predictNextMonth(List<Expense> expenses) {
    if (expenses.isEmpty) return 0;

    final last3Months = expenses
        .where((e) =>
            e.date.isAfter(DateTime.now().subtract(const Duration(days: 90))))
        .toList();

    final total = last3Months.fold(0.0, (s, e) => s + e.amount);
    return total / 3;
  }

  /// Spending pattern tips
  static List<String> generateTips(List<Expense> expenses) {
    final Map<String, double> categoryTotals = {};

    for (var e in expenses) {
      categoryTotals[e.category] =
          (categoryTotals[e.category] ?? 0) + e.amount;
    }

    if (categoryTotals.isEmpty) return [];

    final maxCategory = categoryTotals.entries
        .reduce((a, b) => a.value > b.value ? a : b);

    return [
      "You spend most on ${maxCategory.key}. Consider reducing it.",
    ];
  }

  /// Detect unusual expenses (simple anomaly)
  static List<Expense> detectUnusual(List<Expense> expenses) {
    if (expenses.length < 5) return [];

    final avg =
        expenses.fold(0.0, (s, e) => s + e.amount) / expenses.length;

    return expenses.where((e) => e.amount > avg * 2).toList();
  }
}
