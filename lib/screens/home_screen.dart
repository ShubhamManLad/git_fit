import 'package:flutter/material.dart';
import 'package:git_fit/components/dialog_box.dart';
import 'package:git_fit/components/fab.dart';
import 'package:git_fit/components/progress_map.dart';
import 'package:git_fit/components/task_item.dart';
import 'package:git_fit/model/task_model.dart';
import 'package:git_fit/screens/enter_screen.dart';
import 'package:git_fit/screens/explore_screen.dart';
import 'package:git_fit/services/date_time.dart';
import 'package:git_fit/services/habit_database.dart';
import 'package:hive/hive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:git_fit/services/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home_Screen extends StatefulWidget {
  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {
  List todays_tasks = [];
  String startDate = '';
  String? emailID;
  Map<DateTime, int> dataset = {};
  Habit_Database db = Habit_Database();
  var box = Hive.box('Habit_Database');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailID = FirebaseAuth.instance.currentUser?.email;
    if (box.get('START_DATE') == null) {
      db.createDefaultDB();
      print('NO DB');
    }
    startDate = box.get('START_DATE');
    if (box.get(getTodaysDate()) == null) {
      print('New Day');
      db.createTodayDB();
    }
    todays_tasks = db.getTodaysTasks();
    print(todays_tasks);
    dataset = db.getDatasets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white24,
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.label,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title: Text('G i t   F i t',style: TextStyle(fontWeight: FontWeight.w600),),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                DrawerHeader(
                    child: Column(
                      children: [
                        Image(image: AssetImage('images/person.png'),),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(emailID!,style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    )
                ),
                ListTile(
                  title: Text('Find Friends',style: TextStyle(color: Colors.white),),
                  leading: Icon(Icons.search,color: Colors.white),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Explore_Screen()));
                  },
                ),
                ListTile(
                  title: Text('Sync Data',style: TextStyle(color: Colors.white)),
                  leading: Icon(Icons.sync,color: Colors.white),
                  onTap: db.setFirebaseDataset,
                ),
              ],
            ),
            ListTile(
              title: Text('Logout',style: TextStyle(color: Colors.white)),
              leading: Icon(Icons.logout,color: Colors.white,),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Enter_Screen()));
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Progress_Map(startDate: startDate, dataset: dataset)),
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: todays_tasks.length,
                    itemBuilder: (context, index) {
                      return Task_Item(
                        task: todays_tasks[index]['task'],
                        isDone: todays_tasks[index]['isDone'],
                        onChanged: (value) {
                          setState(() {
                            todays_tasks = db.markTask(index, value!);
                            dataset = db.getDatasets();
                          });
                        },
                        editTask: (context) {
                          final textController = TextEditingController();
                          final timeController = TextEditingController();
                          textController.text = todays_tasks[index]['task'];
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog_Box(
                                  hintText: 'Enter new Task',
                                  textController: textController,
                                  timeController: timeController,
                                  onSubmit: () {
                                    String task_title = textController.text;

                                    Task_Model task = Task_Model('${getTime()}',
                                        task_title, false, DateTime.now());
                                    DateTime alarm = DateTime.now().add(Duration(minutes: 1));
                                    print(alarm);
                                    Notification_Service notify = Notification_Service();
                                    notify.showNotification();
                                    notify.scheduleNotification(scheduledNotificationDateTime: alarm);
                                    setState(() {
                                      todays_tasks = db.editTask(index,task);
                                      dataset = db.getDatasets();
                                    });

                                    Navigator.pop(context);
                                  },
                                );
                              });

                          Task_Model task = Task_Model('${getTime()}',
                              'Cycle 2KM', false, DateTime.now());
                          setState(() {
                            todays_tasks = db.editTask(index, task);
                          });
                        },
                        deleteTask: (context) {
                          setState(() {
                            todays_tasks = db.deleteTask(index);
                            dataset = db.getDatasets();
                          });
                        },
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Fab(
        onPressed: () {
          db.setFirebaseDataset();
          Notification_Service notify = Notification_Service();
          notify.showNotification();
          final textController = TextEditingController();
          final timeController = TextEditingController();
          showDialog(
              context: context,
              builder: (context) {
                return Dialog_Box(
                  hintText: 'Enter new Task',
                  textController: textController,
                  timeController: timeController,
                  onSubmit: () {
                    String task_title = textController.text;
                    print(task_title);
                    String time = timeController.text;
                    int hr = int.parse(time.split(':')[0]);
                    int min = int.parse(time.split(':')[1]);
                    DateTime alarm = getDate(getTodaysDate()).add(Duration(minutes: min,hours: hr));
                    print(alarm);
                    Notification_Service notification_service = Notification_Service();
                    notification_service.scheduleNotification(scheduledNotificationDateTime: alarm);
                    Task_Model task = Task_Model(
                        '${getTime()}', task_title, false, DateTime.now());
                    setState(() {
                      todays_tasks = db.addTask(task);
                      dataset = db.getDatasets();
                    });
                    Navigator.pop(context);
                  },
                );
              });
        },
      ),
    );
  }
}
