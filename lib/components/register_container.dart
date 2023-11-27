import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:git_fit/screens/home_screen.dart';


class Register_Container extends StatefulWidget {

  @override
  State<Register_Container> createState() => _Register_ContainerState();
}

class _Register_ContainerState extends State<Register_Container> {

  bool showPassword = true;

  late String name;
  late String emailID;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Name
        Padding(
          padding: EdgeInsets.all(16.0),
          child: TextField(
            onChanged: (value){
              name = value;
            },
            style: TextStyle(
              color: Colors.green,
            ),
            cursorColor: Colors.green,
            decoration: InputDecoration(
                labelText: 'Name',
                labelStyle:  TextStyle(
                  color: Colors.green,
                ),
                floatingLabelStyle: TextStyle(
                  color: Colors.green,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                )
            ),
          ),
        ),

        //Email ID
        Padding(
          padding: EdgeInsets.all(16.0),
          child: TextField(
            onChanged: (value){
              emailID = value;
            },
            style: TextStyle(
              color: Colors.green,
            ),
            cursorColor: Colors.green,
            decoration: InputDecoration(
                labelText: 'Email ID',
                labelStyle:  TextStyle(
                  color: Colors.green,
                ),
                floatingLabelStyle: TextStyle(
                  color: Colors.green,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                )
            ),
          ),
        ),

        // Password
        Padding(
          padding: EdgeInsets.all(16.0),
          child: TextField(
            onChanged: (value) {
              password = value;
            },
            style: TextStyle(
              color: Colors.green,
            ),
            obscureText: showPassword,
            cursorColor: Colors.green,
            decoration: InputDecoration(
                labelText: 'Password',
                labelStyle:  TextStyle(
                  color: Colors.green,
                ),
                floatingLabelStyle: TextStyle(
                  color: Colors.green,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                suffix: GestureDetector(
                  onTap: (){
                    showPassword = !showPassword;
                  },
                  child: Icon(
                      showPassword ? Icons.visibility_off_outlined:Icons.visibility_outlined
                  ),
                )
            ),

          ),
        ),


        TextButton(
          onPressed: ()async{
            UserCredential userCred = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailID, password: password);
            User? user = await FirebaseAuth.instance.currentUser;
            Navigator.push(context, MaterialPageRoute(builder: (context)=> Home_Screen()));
          },
          child: Text(
              'Register',
              style: TextStyle(
                color: Colors.white,
              )
          ),
          style: ElevatedButton.styleFrom(
            onPrimary: Colors.black87,
            backgroundColor: Colors.green,
            minimumSize: Size(88, 36),
            padding: EdgeInsets.symmetric(horizontal: 16),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
          ),
        ),

      ],
    );
  }
}
