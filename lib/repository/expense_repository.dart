import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_daily_expense/model/expense_model.dart';

class ExpenseRepository {
  final CollectionReference _collection = FirebaseFirestore.instance.collection(
    'expenses',
  );

  Future<void> addExpense(ExpenseModel expense) async {
    await _collection.add(expense.toJson());
  }

  Stream<List<ExpenseModel>> watchExpenses() {
    return _collection.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => ExpenseModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList(),
    );
  }

  Stream<List<ExpenseModel>> getExpenses() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs
          .map(
            (doc) => ExpenseModel.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList();
    });
  }

  Future<void> updateExpense(ExpenseModel expense) async {
    await _collection.doc(expense.id).update(expense.toJson());
  }

  Future<void> deleteExpense(String id) async {
    await _collection.doc(id).delete();
  }
}
