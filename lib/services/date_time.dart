import 'package:flutter/material.dart';

String getTodaysDate(){
  DateTime today = DateTime.now();
  int year = today.year;
  int month = today.month;
  int date = today.day;
  return '$year/$month/$date';
}

String getStringDate(DateTime today){
  int year = today.year;
  int month = today.month;
  int date = today.day;
  return '$year/$month/$date';
}

int getTime(){
  DateTime today = DateTime.now();
  return today.millisecondsSinceEpoch;
}

DateTime getDate(String startDate){
  List s = startDate.split('/');
  int y = int.parse(s[0]);
  int m = int.parse(s[1]);
  int d = int.parse(s[2]);
  DateTime date = DateTime(y,m,d);

  return date;

}