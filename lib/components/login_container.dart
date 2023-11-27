import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:git_fit/screens/home_screen.dart';


class Login_Container extends StatefulWidget {

  @override
  State<Login_Container> createState() => _Login_ContainerState();
}

class _Login_ContainerState extends State<Login_Container> {

  bool showPassword = true;

  late String emailID;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Email ID
        Padding(
          padding: EdgeInsets.all(16.0),
          child: TextField(
            onChanged: (value){
              emailID = value;
            },
            style: TextStyle(
              color: Colors.green,
            ),
            cursorColor: Colors.orangeAccent,
            decoration: InputDecoration(
                labelText: 'Email ID',
                labelStyle: TextStyle(
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
            onChanged: (value){
              password = value;
            },
            style: TextStyle(
              color: Colors.green,
            ),
            obscureText: showPassword,
            cursorColor: Colors.orangeAccent,
            decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(
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
                    setState(() {
                      showPassword = !showPassword;
                    });
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
            await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailID, password: password);
            print(await FirebaseAuth.instance.currentUser?.displayName);
            Navigator.push(context, MaterialPageRoute(builder: (context)=> Home_Screen()));
          },
          child: Text(
              'Login',
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
