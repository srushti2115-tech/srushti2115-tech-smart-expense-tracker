import '../models/expense_model.dart';

double totalExpenses(List<Expense> expenses) {
  return expenses.fold(0, (sum, e) => sum + e.amount);
}

Map<String, double> categoryTotals(List<Expense> expenses) {
  final Map<String, double> data = {};
  for (var e in expenses) {
    data[e.category] = (data[e.category] ?? 0) + e.amount;
  }
  return data;
}
List<String> checkOverspending(
  Map<String, double> budgets,
  Map<String, double> spending,
) {
  final List<String> alerts = [];

  budgets.forEach((category, limit) {
    final spent = spending[category] ?? 0;
    if (spent > limit) {
      alerts.add("Overspending on $category");
    }
  });

  return alerts;
}
