import '../models/expense_model.dart';

Map<int, double> calculateMonthlyTotals(List<Expense> expenses) {
  final Map<int, double> monthlyTotals = {};

  for (var expense in expenses) {
    final month = expense.date.month;
    monthlyTotals[month] =
        (monthlyTotals[month] ?? 0) + expense.amount;
  }

  return monthlyTotals;
}
