import 'package:expense_app/pages/add_expense.dart';
import 'package:expense_app/pages/expenses.dart';
import 'package:expense_app/pages/reports.dart';
import 'package:expense_app/pages/settings.dart';
import 'package:flutter/material.dart';

class TabsController extends StatefulWidget {
  const TabsController({super.key});

  @override
  State<TabsController> createState() => _TabsControllerState();
}

class _TabsControllerState extends State<TabsController> {
  var _selectedIndex = 0;

  final List _pages = [
    Expenses(),
    Reports(),
    AddExpense(),
    Settings(),
  ];

  // Titles for each tab if needed
  final List<String> _titles = [
    'Expenses',
    'Reports',
    'Add Expense',
    'Settings'
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: Text(_titles[_selectedIndex]), // Use _titles for the title
            backgroundColor: Colors.black,
            centerTitle: true,
          ),
          body: _pages[_selectedIndex],
          backgroundColor: Colors.black,
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.black,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.paid),
                label: 'Expenses',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart),
                label: 'Reports',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: 'Add',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.blue, // Optional: specify selected color
            unselectedItemColor:
                Colors.grey, // Optional: specify unselected color
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
          ),
        ));
  }
}
