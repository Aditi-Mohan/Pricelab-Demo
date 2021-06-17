import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/logo_screen.dart';

Map<int, Color> color =
{
  50:Color.fromRGBO(113, 245, 51, 1),
  100:Color.fromRGBO(113, 245, 51, 1),
  200:Color.fromRGBO(113, 245, 51, 1),
  300:Color.fromRGBO(113, 245, 51, 1),
  400:Color.fromRGBO(113, 245, 51, 1),
  500:Color.fromRGBO(113, 245, 51, 1),
  600:Color.fromRGBO(113, 245, 51, 1),
  700:Color.fromRGBO(113, 245, 51, 1),
  800:Color.fromRGBO(113, 245, 51, 1),
  900:Color.fromRGBO(113, 245, 51, 1),
};

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'JosefinSans',
        primarySwatch: MaterialColor(0xFF71F533, color),
        accentColor: Color(0xFF90CD7B),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      await Future.delayed(Duration(milliseconds: 200))
          .then((value) => Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: Duration(seconds: 2),
          pageBuilder: (_,__,___) => LogoScreen()
        )
      ));
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Row(
        children: [
          Hero(
            tag: "box1",
            child: Container(
              width: MediaQuery.of(context).size.width/4,
              height: MediaQuery.of(context).size.height,
              color: Theme.of(context).accentColor,
            ),
          ),
          Hero(
            tag: "box2",
            child: Container(
              width: MediaQuery.of(context).size.width/4,
              height: MediaQuery.of(context).size.height,
              color: Theme.of(context).accentColor,
            ),
          ),
          Hero(
            tag: "box3",
            child: Container(
              width: MediaQuery.of(context).size.width/4,
              height: MediaQuery.of(context).size.height,
              color: Theme.of(context).accentColor,
            ),
          ),
          Hero(
            tag: "box4",
            child: Container(
              width: MediaQuery.of(context).size.width/4,
              height: MediaQuery.of(context).size.height,
              color: Theme.of(context).accentColor,
            ),
          ),
        ],
      ),
    );
  }
}
