import 'dart:io';

import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

import '../models/expense_model.dart';

class ExportService {
  // =========================
  // 📄 CSV EXPORT
  // =========================
  static Future<File> exportToCSV(List<Expense> expenses) async {
    final List<List<dynamic>> rows = [
      ["Title", "Category", "Amount", "Date"],
    ];

    for (final e in expenses) {
      rows.add([
        e.title,
        e.category,
        e.amount.toStringAsFixed(2),
        _formatDate(e.date),
      ]);
    }

    final csvData = const ListToCsvConverter().convert(rows);
    final directory = await getApplicationDocumentsDirectory();
    final file = File("${directory.path}/expenses.csv");

    return await file.writeAsString(csvData);
  }

  // =========================
  // 📄 PDF EXPORT
  // =========================
  static Future<File> exportToPDF(List<Expense> expenses) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text(
            "Expense Report",
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 16),

          pw.Table.fromTextArray(
            headers: ["Title", "Category", "Amount", "Date"],
            data: expenses.map((e) {
              return [
                e.title,
                e.category,
                "₹${e.amount.toStringAsFixed(2)}",
                _formatDate(e.date),
              ];
            }).toList(),
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            ),
            headerDecoration: const pw.BoxDecoration(
              color: PdfColors.grey300, // ✅ FIXED
            ),
            cellAlignment: pw.Alignment.centerLeft,
          ),
        ],
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final file = File("${directory.path}/expenses.pdf");

    await file.writeAsBytes(await pdf.save());
    return file;
  }

  // =========================
  // 📅 Date Formatter
  // =========================
  static String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
