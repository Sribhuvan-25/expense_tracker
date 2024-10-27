import 'package:flutter/material.dart';

class CategoryHorizontal extends StatelessWidget {
  final String categoryName;
  final Color categoryColor;
  CategoryHorizontal({super.key, 
    required this.categoryName,
    required this.categoryColor,
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
          child: Row(
            children: [
              Container(
                width: 15,
                height: 15,
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
        );
  }
}