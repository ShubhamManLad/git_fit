import 'package:flutter/material.dart';

class Task_Model{
  late String id;
  late String task;
  late bool isDone;
  late DateTime dateTime;
  Task_Model(this.id, this.task, this.isDone, this.dateTime);

  Map<String, dynamic> getMap(){
    Map<String, dynamic> data = {
      'id': this.id,
      'task':this.task,
      'isDone':this.isDone,
      'date':this.dateTime,
    };
    return data;
  }

}