import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BudgetService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  String get userId => _auth.currentUser!.uid;

  DocumentReference get budgetRef =>
      _db.collection('users').doc(userId).collection('meta').doc('budgets');

  Future<void> setBudget(String category, double amount) async {
    await budgetRef.set(
      {category: amount},
      SetOptions(merge: true),
    );
  }

  Stream<Map<String, double>> getBudgets() {
    return budgetRef.snapshots().map((doc) {
      if (!doc.exists) return {};
      final data = doc.data() as Map<String, dynamic>;
      return data.map((k, v) => MapEntry(k, (v as num).toDouble()));
    });
  }
}
