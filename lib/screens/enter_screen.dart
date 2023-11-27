import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:git_fit/components/login_container.dart';
import 'package:git_fit/components/register_container.dart';
import 'package:git_fit/screens/home_screen.dart';
enum Status {login, register}

class Enter_Screen extends StatefulWidget {
  const Enter_Screen({super.key});

  @override
  State<Enter_Screen> createState() => _Enter_ScreenState();
}

class _Enter_ScreenState extends State<Enter_Screen> {

  Status current = Status.login;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    if(FirebaseAuth.instance.currentUser!=null){
      return Home_Screen();
    }
    return SafeArea(
        child:Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  child: Column(
                    children: [
                      Expanded(
                        child: Image(
                          image: AssetImage('images/logo.png'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Material(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
                elevation: 5,
                child: Container(
                  height: 500,
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      )
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 16),
                        child: SegmentedButton(
                          showSelectedIcon: false,
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                if (states.contains(MaterialState.selected)){
                                  return Colors.green;
                                }
                                return Colors.black12;
                              },
                            ),
                          ),
                          segments: [
                            ButtonSegment<Status>(value: Status.login, label: Text('Login')),
                            ButtonSegment<Status>(value: Status.register, label: Text('Register')),
                          ],
                          selected:<Status>{current} ,
                          onSelectionChanged: (Set<Status> newSelection){
                            setState(() {
                              current = newSelection.first;
                            });
                          },
                        ),
                      ),
                      current == Status.login ? Login_Container() : Register_Container(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
