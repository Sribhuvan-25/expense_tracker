import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'category_class_utility.g.dart';  // This file will be generated

@HiveType(typeId: 2)
class Category extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final Color color;

  Category({required this.name, required this.color});
}
