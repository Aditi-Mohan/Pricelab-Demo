import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import '/login_screen.dart';

class LogoScreen extends StatefulWidget {
  @override
  _LogoScreenState createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 60+(19*4)+(5*4),
              child: Hero(
                tag: 'name',
                child: DefaultTextStyle(
                  style: TextStyle(
                      color: Color.fromRGBO(28, 202, 150, 1),
                      fontWeight: FontWeight.w600,
                      fontSize: 42,
                  ),
                  child: AnimatedTextKit(
                    repeatForever: false,
                    totalRepeatCount: 2,
                    animatedTexts: [TyperAnimatedText("Pricelab")],
                    onFinished: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              left: 60+(19*3)+(5*3),
              top: ((MediaQuery.of(context).size.height/2)-(57/2))+8,
              child: Hero(
                tag: 'box1',
                child: Container(
                  width: 19,
                  height: 57,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF71F533), Color(0xFF197050)],
                    ),
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                ),
              ),
            ),
            Positioned(
              left: 60+(19*2)+(5*2),
              child: Hero(
                tag: 'box2',
                child: Container(
                  width: 19,
                  height: 57,
                  decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                ),
              ),
            ),
            Positioned(
              left: 60+19+5,
              top: ((MediaQuery.of(context).size.height/2)-(57/2))+8,
              child: Hero(
                tag: 'box3',
                child: Container(
                  width: 19,
                  height: 57,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF44C508), Color(0xFF1A1F1C)],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                ),
              ),
            ),
            Positioned(
              left: 60,
              child: Hero(
                tag: 'box4',
                child: Container(
                  width: 19,
                  height: 57,
                  decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
