import 'package:expense_app/data/database.dart';
import 'package:expense_app/utilities/expense_tile.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Expenses extends StatefulWidget {
  final String title;

  Expenses({Key? key, this.title = "Expenses"}) : super(key: key);

  @override
  _ExpensesState createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final _myBox = Hive.box('expenseTrackerBox');
  ExpenseTrackerDataBase db = ExpenseTrackerDataBase();
  late double total;

  @override
  void initState() {
    super.initState();
    // Initialize data
    if (_myBox.isEmpty) {
      db.createInitialData();
    } else {
      db.loadExpenseData();
    }

    // Calculate the total expense amount
    double sum = db.expenses.fold(0, (acc, expense) => acc + expense[0]);
    total = sum;
    db.updateSumValue('sum', sum);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.attach_money_rounded,
                  size: 27,
                  color: Color.fromARGB(255, 146, 143, 143),
                ),
                Text(
                  total.toStringAsFixed(2), // Format to 2 decimal places
                  style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: db.expenses.length,
              itemBuilder: (context, index) {
                return ExpenseDisplay(
                  amount: db.expenses[index][0],
                  occurence: db.expenses[index][1],
                  date: db.expenses[index][2],
                  note: db.expenses[index][3],
                  category: db.expenses[index][4],
                  color: db.expenses[index][5],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
