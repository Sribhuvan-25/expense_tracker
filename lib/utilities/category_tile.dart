import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CategoryTile extends StatelessWidget {
  final String categoryName;
  final Color categoryColor;
  Function(BuildContext)? deleteFunction;
  CategoryTile({super.key, 
    required this.categoryName,
    required this.categoryColor,
    required this.deleteFunction,
    });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:25, right: 25, top: 15),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.red.shade300,
              borderRadius: BorderRadius.circular(12),
              )
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Color.fromARGB(255, 28, 28, 30),
                      borderRadius: BorderRadius.circular(12)
          ),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                margin: EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  color: categoryColor,
                  shape: BoxShape.circle
                ),
              ),
              //task name
              Text(categoryName,),
            ],
          ),
        ),
      ),
    );
  }
}