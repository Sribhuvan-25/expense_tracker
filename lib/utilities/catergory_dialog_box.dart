import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class DialogBox extends StatefulWidget {
  final controller;
  final void Function(Color) onSave;
  VoidCallback onCancel;

  DialogBox({super.key,
    required this.controller,
    required this.onSave,
    required this.onCancel});

  @override
  _DialogBoxState createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  Color pickerColor = Color(0xff443a49);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromARGB(255, 28, 28, 30),
      content: Container(
        height: 340,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Add a new category"),
            ),
            ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: (color) {
                setState(() {
                  pickerColor = color;
                });
              },
              showLabel: false,
              pickerAreaHeightPercent: 0.4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    child: Text("Save", style: TextStyle(color: Colors.white),),
                    onPressed: () {
                      print("save button pressed");
                      widget.onSave(pickerColor);
                    }),
                const SizedBox(
                  width: 8,
                ),
                TextButton(child: Text("Cancel", style: TextStyle(color: Colors.white),), onPressed: widget.onCancel),
              ],
            )
          ]),
      ),
    );
  }
}
