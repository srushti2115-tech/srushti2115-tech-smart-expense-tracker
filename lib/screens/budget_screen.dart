import 'package:flutter/material.dart';
import '../services/budget_service.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final _service = BudgetService();
  final _amountController = TextEditingController();

  String category = 'Food';

  void saveBudget() async {
    await _service.setBudget(
      category,
      double.parse(_amountController.text),
    );
    _amountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Set Budget")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButton<String>(
              value: category,
              items: ['Food', 'Travel', 'Rent', 'Shopping']
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => category = v!),
            ),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Monthly Budget"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveBudget,
              child: const Text("Save Budget"),
            ),
          ],
        ),
      ),
    );
  }
}
