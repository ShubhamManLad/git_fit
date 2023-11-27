import 'package:flutter/material.dart';
import 'package:git_fit/components/progress_map.dart';
import 'package:git_fit/services/habit_database.dart';
class Explore_Screen extends StatefulWidget {
  const Explore_Screen({super.key});

  @override
  State<Explore_Screen> createState() => _Explore_ScreenState();
}

class _Explore_ScreenState extends State<Explore_Screen> {

  final TextEditingController controller = TextEditingController();
  String emailID = '';

  Map<DateTime, int> dataset = {};
  Habit_Database db = Habit_Database();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: controller,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      labelText: 'Email ID',

                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      hintText: 'Enter userID:',
                      suffix: IconButton(
                        icon: Icon(Icons.search,color: Colors.green,),
                        onPressed: (){
                          setState(() {
                            emailID = controller.text;
                        });
                      },
                    )
                  ),
                ),
              ),
              Details(emailID: emailID, db: db)
            ],
          ),
        ),
      ),
    );
  }

}

class Details extends StatelessWidget {
  String emailID;
  Habit_Database db;
  Details({required this.emailID, required this.db});


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: db.getFirebaseDataset(emailID),
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.done && snapshot.hasData ){
            if(snapshot.data!['error']=='Nodata'){
              return Text('No data found',style: TextStyle(color: Colors.white),);
            }
            else {
              String startDate = snapshot.data!['startDate'];
              Map<DateTime, int> dataset = snapshot.data!['dataset'];
              return Progress_Map(startDate: startDate, dataset: dataset);
            }
          }
          return Text('No data found',style: TextStyle(color: Colors.white),);
        });
  }
}

