import 'package:flutter/material.dart';

class ExpenseDisplay extends StatelessWidget {
  final num amount;
  final String occurence;
  final DateTime date;
  final String note;
  final String category;
  final Color color;

  ExpenseDisplay(
      {super.key,
      required this.amount,
      required this.occurence,
      required this.date,
      required this.note,
      required this.category,
      required this.color
      });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const BeveledRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      color: const Color.fromARGB(180, 30, 30, 30),
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                child: Text(
                  note,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(9),
                child: Text(
                  'USD ${amount.toString()}',
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.all(9),
                decoration: BoxDecoration(
                    color: color,
                    borderRadius:
                        const BorderRadius.all(Radius.elliptical(45, 50))),
                padding:
                    const EdgeInsets.symmetric(vertical: 3, horizontal: 12),
                child: Text(category),
              ),
              Container(
                padding: const EdgeInsets.all(9),
                child: Text(date.toString().split(' ')[0]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
