import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_daily_expense/model/expense_category.dart';

class CategoryRepository {
  final CollectionReference _collection = FirebaseFirestore.instance.collection(
    'categories',
  );

  Stream<List<ExpenseCategory>> watchCategories() {
    return _collection.snapshots().map(
      (snapshot) => snapshot.docs
          .map(
            (doc) =>
                ExpenseCategory.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  Future<void> addCategory(ExpenseCategory category) async {
    await _collection.add(category.toJson());
  }
}
