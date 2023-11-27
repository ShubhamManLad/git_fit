import 'package:flutter/material.dart';

class Fab extends StatelessWidget {

  Function() onPressed;

  Fab({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: Icon(Icons.add),
    );
  }
}
