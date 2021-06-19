import 'package:flutter/material.dart';

import 'dashboard_screen.dart';
import 'utils/route_animation.dart';
import 'services/auth_service.dart';
import 'utils/google_signin_button.dart';
import 'utils/showup_animation.dart';
import 'utils/logo.dart';
import '/home_page.dart';
import '/recent_page.dart';

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
            padding: const EdgeInsets.fromLTRB(0, 30+50, 0, 0),
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
              child: GestureDetector(
                onTap: () async {
                  AuthService auth = AuthService();
                  bool res = await auth.signInWithGoogle();
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0))
                          ),
                          backgroundColor: Colors.white,
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 2),
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  height: 30,
                                  child: Text(auth.message,
                                    style: TextStyle(
                                      color: Color.fromRGBO(25, 112, 80, 1),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                    ),
                                  )
                              ),
                            ],
                          )
                      )
                  );
                  print(res);
                  if(res) {
                    bool dec = await auth.userExists();
                    print(dec);
                    if(dec) {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => RecentScreen()));
                    }
                    else {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => HomePage()));
                    }
                  }
                },
                  child: GoogleSignInButton()
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: ShowUp(
              delay: 1,
              child: Text("Or",
                style: TextStyle(
                  color: Color.fromRGBO(104, 132, 95, 0.75),
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: ShowUp(
              delay: 1,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(NextPageRoute(nextScreen: DashBoardScreen()));
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Color.fromRGBO(193, 193, 193, 1))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(38.0, 8.0, 38.0, 8.0),
                          child: Text("Go to Dashboard",
                            style: TextStyle(
                              color: Color.fromRGBO(104, 132, 95, 0.75),
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
