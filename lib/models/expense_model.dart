class Expense {
  final String id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
    };
  }

  factory Expense.fromMap(String id, Map<String, dynamic> data) {
    return Expense(
      id: id,
      title: data['title'],
      amount: data['amount'],
      category: data['category'],
      date: DateTime.parse(data['date']),
    );
  }
}
