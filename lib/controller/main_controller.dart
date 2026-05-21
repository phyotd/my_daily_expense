import 'package:flutter/material.dart';
import 'package:my_daily_expense/controller/base_controller.dart';

class MainController extends ChangeNotifier {
  List<BaseController> get controllers => [];

  void addController(BaseController controller) {
    controllers.add(controller);
    notifyListeners();
  }

  void login() {
    for (var controller in controllers) {
      controller.login();
    }
  }

  void logout() {
    for (var controller in controllers) {
      controller.logout();
    }
  }
}
