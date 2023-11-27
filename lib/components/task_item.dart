import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Task_Item extends StatelessWidget {
  final String task;
  final bool isDone;
  final Function(bool?)? onChanged;
  final Function(BuildContext) editTask;
  final Function(BuildContext) deleteTask;

  Task_Item({
    required this.task,
    required this.isDone,
    required this.onChanged,
    required this.editTask,
    required this.deleteTask,});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: editTask,
              backgroundColor: Colors.black12,
              icon: Icons.edit,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            SlidableAction(
              onPressed: deleteTask,
              backgroundColor: Colors.red,
              icon: Icons.delete,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            )
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green[600],
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Row(
            children: [
              Checkbox(value: isDone, onChanged: onChanged),
              Text(task,style: TextStyle(color: Colors.white),),
            ],
          ),
        ),
      ),
    );
  }
}
