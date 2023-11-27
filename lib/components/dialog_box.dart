import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';

class Dialog_Box extends StatelessWidget {

  final TextEditingController textController;
  final TextEditingController timeController;
  final VoidCallback onSubmit;
  final String hintText;
  Dialog_Box({required this.textController,required this.timeController, required this.onSubmit, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(

      title: Text('Add New Task'),
      content: Wrap(
        children: [
          Column(
            children: [
              TextField(
                controller: textController,
                decoration: InputDecoration(hintText: hintText),
              ),
              DateTimePicker(
                type: DateTimePickerType.time,
                controller: timeController,

              )
            ],
          ),
        ]
      ),
      actions: [
        TextButton(
            onPressed: onSubmit,
            child: Text('Submit'))
      ],
    );
  }
}
