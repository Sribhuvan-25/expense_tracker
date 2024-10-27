import 'package:expense_app/utilities/category_class_utility.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ExpenseTrackerDataBase {
  List<Category> categories = [];
  List<dynamic> expenses = [];
  double sum = 0;

  final dataBox = Hive.box("expenseTrackerBox");

  void createInitialData() {
    categories = [
      Category(name: "Bills", color: Color(0xFFFFBF00)),
      Category(name: "Take Out",color: Color(0xFF0000FF)),
      Category(name: "Rent", color: Color(0xFF00FF00)),
      Category(name: "Groceries", color: Color(0xFFFF9B0F))
    ];
    expenses = [
      [11.0, "weekly", DateTime(2023, 10, 20), "Note", "Groceries", Color(0xFFFF9B0F)],
      [13.0, "none", DateTime(2023, 10, 19), "Note", "Groceries", Color(0xFFFF9B0F)],
    ];
    dataBox.put("CATEGORIES", categories);
    dataBox.put("EXPENSES", expenses);
  }

  void loadData() async {
    final categoriesData = dataBox.get("CATEGORIES");
    categories = List<Category>.from(categoriesData);
  }

  Future<void> updateData() async {
    dataBox.put("CATEGORIES", categories);
  }

  void loadExpenseData() {
    expenses = dataBox.get("EXPENSES");
  }

  void addExpense(List<dynamic> newExpense) {
    expenses.add(newExpense);
  }

  Future<void> updateExpenseData() async {
    dataBox.put("EXPENSES", expenses);
  }

  Future<void> updateSumValue(String key, double newValue) async {
    await dataBox.put(key, newValue);
  }

}
