import 'package:expense_app/data/database.dart';
import 'package:expense_app/utilities/category_class_utility.dart';
import 'package:expense_app/utilities/category_tile.dart';
import 'package:expense_app/utilities/catergory_dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});
  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final _myBox = Hive.box('expenseTrackerBox');
  ExpenseTrackerDataBase db = ExpenseTrackerDataBase();
  final _controller = TextEditingController();

  @override
  void initState() {
    // If this is the first time ever opening the app, initialize with default data
    if (_myBox.isEmpty) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    super.initState();
  }

  void deleteCategory(int index) {
    setState(() {
      db.categories.removeAt(index);
    });
    db.updateData();
  }

  void saveCategory(Color selectedColor) async {
    if (_controller.text.isEmpty) return; // Avoid saving empty category names
    var categoryName = _controller.text;
    print('Saving category with name: $categoryName and color: $selectedColor');
    setState(() {
      db.categories.add(Category(name: categoryName, color: selectedColor));
      _controller.clear();
    });
    Navigator.of(context).pop();
    await db.updateData();
    debugPrint(db.categories.toString());
  }

  // Opens dialog to create a new category
  void createCategory() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: (selectedColor) {
            saveCategory(selectedColor);
          },
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Categories"),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        onPressed: createCategory,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: db.categories.length,
        itemBuilder: (context, index) {
          debugPrint(db.categories[index].color.toString());
          return CategoryTile(
            categoryName: db.categories[index].name,
            categoryColor: db.categories[index].color,
            deleteFunction: (context) => deleteCategory(index),
          );
        },
      ),
    );
  }
}
