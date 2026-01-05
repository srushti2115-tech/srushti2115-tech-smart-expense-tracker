import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/expense_model.dart';

class ExpenseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String get userId => _auth.currentUser!.uid;

  CollectionReference get expenseRef =>
      _db.collection('users').doc(userId).collection('expenses');

  Future<void> addExpense(Expense expense) async {
    await expenseRef.add(expense.toMap());
  }

  Stream<List<Expense>> getExpenses() {
    return expenseRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Expense.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<void> deleteExpense(String id) async {
    await expenseRef.doc(id).delete();
  }
}
