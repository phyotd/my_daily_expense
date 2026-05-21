
import 'package:flutter/material.dart';
import 'package:my_daily_expense/controller/expense_category_controller.dart';
import 'package:my_daily_expense/controller/expense_controller.dart';
import 'package:my_daily_expense/controller/main_controller.dart';
import 'package:my_daily_expense/screens/expense_screen.dart';
import 'package:my_daily_expense/screens/home_screen.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final mainController = MainController();
  final expenseController = ExpenseController();
  final expenseCategoryController = ExpenseCategoryController();

@override
  void initState() {
    mainController.addController(expenseController);
    mainController.addController(expenseCategoryController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: mainController),
        ChangeNotifierProvider.value(value: expenseController),
        ChangeNotifierProvider.value(value: expenseCategoryController),
      ],
      child: MaterialApp(
        title: 'My Daily Expense',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: HomeScreen(),
      ),
    );
  }
}
