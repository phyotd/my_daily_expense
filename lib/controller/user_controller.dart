import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_daily_expense/model/user_model.dart';
import 'package:my_daily_expense/repository/user_repository.dart';

class UserController extends ChangeNotifier {
  final UserRepository _userRepository;

  UserController(this._userRepository);

  StreamSubscription? _subscription;
  UserModel? currentUser;

  void startListening() {
    _subscription = _userRepository.watchUsers().listen((users) {
      currentUser = users.isNotEmpty ? users.first : null;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
