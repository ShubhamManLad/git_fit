import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:git_fit/model/task_model.dart';
import 'package:git_fit/services/date_time.dart';
import 'package:hive/hive.dart';

final box = Hive.box('Habit_Database');

class Habit_Database{

  List<dynamic> todays_task = [];
  Map<DateTime, int> dataset =  {};

  Future<void> createDefaultDB()async {
    await box.put('START_DATE', getTodaysDate());

  }

  Future<void> createTodayDB()async{
    Task_Model task = Task_Model('${getTime()}','Morning Jog',false,DateTime.now());
    todays_task.add(task.getMap());
    await box.put(getTodaysDate(),todays_task);

  }

  List<dynamic> getTodaysTasks(){
    return(box.get(getTodaysDate()));
  }

  List<dynamic> addTask(Task_Model task){
    todays_task = box.get(getTodaysDate());
    todays_task.add(task.getMap());
    box.put(getTodaysDate(),todays_task);

    return getTodaysTasks();

  }

  List<dynamic> editTask(int index, Task_Model task){
    todays_task = box.get(getTodaysDate());
    todays_task[index] = task.getMap();
    box.put(getTodaysDate(),todays_task);
    return getTodaysTasks();
  }

  List<dynamic> deleteTask(int index){
    todays_task = box.get(getTodaysDate());
    todays_task.removeAt(index);
    box.put(getTodaysDate(),todays_task);
    return getTodaysTasks();
  }

  List<dynamic> markTask(int index, bool value){
    todays_task = box.get(getTodaysDate());
    todays_task[index]['isDone'] = value;
    box.put(getTodaysDate(),todays_task);

    int n = todays_task.length;
    int progress = 0;
    for (int i =0; i<n; i++){
      if(todays_task[i]['isDone']){
        progress++;
      }
    }
    double percent = progress/n;
    box.put('${getTodaysDate()}_Progress',percent.toStringAsFixed(1));
    print(box.get('${getTodaysDate()}_Progress'));
    return getTodaysTasks();
  }


  Map<DateTime, int> getDatasets(){

    todays_task = box.get(getTodaysDate());
    int n = todays_task.length;
    int progress = 0;
    for (int i =0; i<n; i++){
      if(todays_task[i]['isDone']){
        progress++;
      }
    }
    double percent = progress/n;
    box.put('${getTodaysDate()}_Progress',percent.toStringAsFixed(1));
    print(box.get('${getTodaysDate()}_Progress'));


    DateTime startDate = getDate(box.get('START_DATE'));
    int days = DateTime.now().difference(startDate).inDays;

    Map<DateTime, int> dataset = {};

    for (int i =0; i<days+1;i++){
      String date = getStringDate(startDate.add(Duration(days: i)));
      print(date);
      double progress = 0;
      if(box.containsKey('${date}_Progress')) {
        progress = double.parse(box.get('${date}_Progress')) * 10;
      }
      int p = progress.toInt();
      print(p);
      final data =<DateTime, int> {getDate(date):p};
      dataset.addAll(data);
    }
    return dataset;

  }

  Map<String,int> setFirebaseDataset(){
    String? email = FirebaseAuth.instance.currentUser?.email;
    var cloud = FirebaseFirestore.instance.collection('Progress');
    Map<DateTime, int> temp = getDatasets();
    Map<String, int> data = {};
    temp.forEach((key, value) {
      String date = getStringDate(key);
      int progress = value;
      final val = <String,int> {date:progress};
      data.addAll(val);
    });
    cloud.doc(email).set({'data':data,'startDate':box.get('START_DATE')});
    return data;
  }

  Future<Map<String, dynamic>> getFirebaseDataset(String emailID)async {
    var cloud = FirebaseFirestore.instance.collection('Progress').doc(emailID);

    Map<DateTime, int> dataset = {};
    Map<String, dynamic> temp = {};
    Map<String, dynamic> data = {};
    String startDate = '';
    await cloud.get().then((value){
      if (value.exists) {
        startDate = value.get('startDate');
        temp = value.get('data');
        print('found');
        temp.forEach((key, value) {
          DateTime date = getDate(key);
          int progress = value;
          final d =<DateTime, int> {date:progress};
          dataset.addAll(d);
        });
        data={
          'startDate':startDate,
          'dataset':dataset
        };
      }
      else{
        print('not found');
        data={
          'error':'Nodata'
        };
      }
    });
    print(data);
    return data;
    //print(data);
    // cloud.doc(email).set({'data':data,'startDate':box.get('START_DATE')});
    // return data;
  }

}