import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_daily_expense/model/user_model.dart';

class UserRepository {
  final DocumentReference _document = FirebaseFirestore.instance
      .collection('users')
      .doc('KfPRy4uE18aiEG6ezEOB');

  Stream<List<UserModel>> watchUsers() {
    return _document.snapshots().map((snapshot) {
      return [UserModel.fromJson(snapshot.data() as Map<String, dynamic>)];
    });
  }

  Future<void> addUser(UserModel user) async {
    await _document.set(user.toJson());
  }

  Future<void> updateUser(UserModel user) async {
    await _document.update(user.toJson());
  }

  Future<void> deleteUser(String userId) async {
    await _document.delete();
  }
}
