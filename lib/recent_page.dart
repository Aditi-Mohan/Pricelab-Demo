import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'services/auth_service.dart';
import 'utils/route_animation.dart';
import 'home_page.dart';
import 'models/offer.dart';
import 'utils/showup_animation.dart';

class RecentScreen extends StatefulWidget {
  @override
  _RecentScreenState createState() => _RecentScreenState();
}

class _RecentScreenState extends State<RecentScreen> {
  List<Offer> offers = [];

  onBack(value) {
    if(value)
      setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 30 + 60, 0, 0),
          child: ShowUp(
            delay: 1,
            child: Text(
              "Recently Used Offers",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(104, 132, 95, 0.75),
                fontWeight: FontWeight.w400,
                fontSize: 30,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 5),
          child: ShowUp(
            delay: 1,
            child: Text(
              "Reuse them",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(104, 132, 95, 0.75),
                fontWeight: FontWeight.w400,
                fontSize: 22,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ShowUp(
            delay: 1,
            child: Container(
              height: 500,
              child: FutureBuilder(
                future: AuthService().getRecentOffers(),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.done) {
                    offers = snapshot.data as List<Offer>;
                    return ListView.builder(
                      itemCount: offers.length,
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  offers[i].title,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Color.fromRGBO(104, 132, 95, 1),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  "Lorem ipsum dolor sit amet, consectetur elit, sed do eiusmod tempor incididunt ut labore",
                                  style: TextStyle(
                                    color: Color.fromRGBO(132, 132, 132, 1),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  offers[i].description ?? "",
                                  style: TextStyle(
                                    color: Color.fromRGBO(39, 123, 98, 1),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13,
                                  ),
                                ),
                                ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateColor.resolveWith((states) => Color.fromRGBO(196, 196, 196, 1)),
                                    ),
                                    onPressed: () async {
                                      Clipboard.setData(ClipboardData(text: offers[i].promoCode));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                          SnackBar(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(10.0))
                                              ),
                                              backgroundColor: Colors.white,
                                              behavior: SnackBarBehavior.floating,
                                              duration: Duration(seconds: 1),
                                              content: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                      height: 30,
                                                      child: Text("Copied to Clipboard!",
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
                                      //Navigator.of(context).pop();
                                      //await AuthService().recentOffers(offers[i]);
                                    },
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                        child: Text("Use Offer",
                                          style: TextStyle(
                                            color: Color.fromRGBO(104, 132, 95, 1),
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  else {
                    return Container();
                  }
                },
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
          child: ShowUp(
            delay: 1,
            child: Text(
              " Or Checkout New Ones",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(104, 132, 95, 0.75),
                fontWeight: FontWeight.w400,
                fontSize: 22,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(NextPageRoute(nextScreen: HomePage())).then(onBack);
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 10),
            child: ShowUp(
              delay: 1,
              child: Icon(
                Icons.arrow_forward_ios,
                color: Color.fromRGBO(104, 132, 95, 0.75),
                size: 32,
              )
            ),
          ),
        ),
      ]),
    );
  }
}
