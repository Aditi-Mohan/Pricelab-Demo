import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import 'utils/google_signin_button.dart';


import 'utils/showup_animation.dart';
import 'utils/logo.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: Logo(height: 60, width: MediaQuery.of(context).size.width),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 120, 0, 0),
            child: ShowUp(
              delay: 1,
              child: Text("Sign up or Login with your Google Account",
                style: TextStyle(
                  color: Color.fromRGBO(104, 132, 95, 0.75),
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 45, 0, 0),
            child: ShowUp(
              delay: 1,
              child: GoogleSignInButton(),
            ),
          ),
        ],
      ),
    );
  }
}
