import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:printing/printing.dart';

import '../services/export_service.dart';
import '../services/expense_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final expenseService = ExpenseService();

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 👤 Profile Header
          const CircleAvatar(
            radius: 40,
            child: Icon(Icons.person, size: 40),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              user?.email ?? "",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

          const SizedBox(height: 30),
          const Divider(),

          // 📄 EXPORT CSV
          ListTile(
            leading: const Icon(Icons.table_chart),
            title: const Text("Export Expenses (CSV)"),
            subtitle: const Text("Excel / Google Sheets"),
            onTap: () async {
              final expenses =
                  await expenseService.getExpenses().first;
              final file =
                  await ExportService.exportToCSV(expenses);

              await Printing.sharePdf(
                bytes: await file.readAsBytes(),
                filename: "expenses.csv",
              );
            },
          ),

          // 📄 EXPORT PDF
          ListTile(
            leading: const Icon(Icons.picture_as_pdf),
            title: const Text("Export Expenses (PDF)"),
            subtitle: const Text("Printable report"),
            onTap: () async {
              final expenses =
                  await expenseService.getExpenses().first;
              final file =
                  await ExportService.exportToPDF(expenses);

              await Printing.sharePdf(
                bytes: await file.readAsBytes(),
                filename: "expenses.pdf",
              );
            },
          ),

          const Divider(),

          // 🚪 LOGOUT
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              "Logout",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
    );
  }
}
