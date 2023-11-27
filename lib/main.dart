import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:git_fit/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:git_fit/screens/enter_screen.dart';
import 'package:git_fit/screens/home_screen.dart';
import 'package:git_fit/services/notification_service.dart';
import 'package:hive/hive.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  await Hive.openBox('Habit_Database');
  tz.initializeTimeZones();
  Notification_Service().initNotification();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.green[600],
        primarySwatch: Colors.green
      ),
      home: Enter_Screen(),
    );
  }



}
