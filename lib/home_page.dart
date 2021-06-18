import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pricelabdemo/services/auth_service.dart';

import 'utils/showup_animation.dart';
import 'models/bank.dart';
import 'models/offer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  List<Bank> banks = [];
  List<int> selectedVariants = [];
  bool loaded = false;
  int selectedBank = -1;

  Future<List<Bank>?> getBanksAndVar() async {
    try {
      QuerySnapshot qs = await _firestore.collection("offers").get();
      List<Bank> banks = [];
      qs.docs.forEach((doc) {
        if (doc.data() == null) throw ("Doc empty");
        //print((doc.data() as Map)['variants']);
        List<String> vars = [...(doc.data() as Map)['variants']];
        Bank b = Bank(name: doc.id, variants: vars);
        banks.add(b);
      });
      return banks;
    } catch (err) {
      print("Error: $err");
      return null;
    }
  }

  Future<List<Offer>?> getOffers() async {
    List<String> vars =
        selectedVariants.map((e) => banks[selectedBank].variants![e]).toList();
    try {
      QuerySnapshot q = await _firestore
          .collection("offers")
          .doc(banks[selectedBank].name)
          .collection("variants")
          .get();
      List<Offer> offers = [];
      q.docs.forEach((doc) {
        int index = vars.indexOf(doc.id);
        if (index != -1) {
          if (doc.data() == null) throw ("Doc empty");
          var d = (doc.data() as Map);
          String desc = "Available with " +
              banks[selectedBank].name +
              " " +
              banks[selectedBank].variants![index] +
              " Credit Card";
          Offer o = Offer(
              title: d["offer"], description: desc, promoCode: d["promoCode"]);
          offers.add(o);
        }
      });
      return offers;
    } catch (err) {
      print("Error: $err");
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    getBanksAndVar().then((value) {
      setState(() {
        banks = value as List<Bank>;
        loaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        AuthService auth = AuthService();
        await auth.signOut();
        return true;
      },
      child: Scaffold(
        key: _key,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 30 + 60, 0, 0),
              child: ShowUp(
                delay: 1,
                child: Text(
                  "Welcome!",
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
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: ShowUp(
                delay: 1,
                child: Text(
                  "Please choose the banks you’re affiliated with:",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromRGBO(104, 132, 95, 0.75),
                    fontWeight: FontWeight.w400,
                    fontSize: 26,
                  ),
                ),
              ),
            ),
            Container(
                height: MediaQuery.of(context).size.height -
                    30 -
                    (26 * 2) -
                    90 -
                    30 -
                    30 -
                    (selectedBank != -1 ? 53 : 0),
                child: Builder(
                  builder: (context) {
                    double _height = 63;
                    double _selectedHeight = 400;
                    if (loaded) {
                      return ListView.builder(
                        itemCount: banks.length,
                        itemBuilder: (context, i) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: GestureDetector(
                              onTap: () {
                                if (selectedBank == i) {
                                  setState(() {
                                    selectedBank = -1;
                                  });
                                } else {
                                  setState(() {
                                    selectedBank = i;
                                    selectedVariants = [];
                                  });
                                }
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.fastOutSlowIn,
                                height:
                                    i == selectedBank ? _selectedHeight : _height,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    border: Border.all(
                                        color: Color.fromRGBO(193, 193, 193, 1)),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)),
                                          border: Border.all(
                                              color: Color.fromRGBO(
                                                  193, 193, 193, 1)),
                                          color: i == selectedBank
                                              ? Color.fromRGBO(25, 112, 80, 1)
                                              : Colors.white,
                                        ),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(18.0),
                                              child: Text(
                                                banks[i].name,
                                                style: TextStyle(
                                                  color: i == selectedBank
                                                      ? Colors.white
                                                      : Color.fromRGBO(
                                                          104, 132, 95, 0.75),
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Builder(
                                        builder: (context) {
                                          if (i == selectedBank)
                                            return Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 10.0),
                                              child: Text(
                                                "Please choose your cards",
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      104, 132, 95, 0.75),
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            );
                                          else
                                            return Container();
                                        },
                                      ),
                                      Builder(
                                        builder: (context) {
                                          if (i == selectedBank) {
                                            return Container(
                                              height: 400 - 110,
                                              child: ListView.builder(
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  itemCount:
                                                      banks[i].variants!.length,
                                                  itemBuilder: (context, ind) {
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          20, 0, 20, 10),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          int index =
                                                              selectedVariants
                                                                  .indexOf(ind);
                                                          if (index != -1) {
                                                            setState(() {
                                                              selectedVariants
                                                                  .removeAt(
                                                                      index);
                                                            });
                                                          } else {
                                                            setState(() {
                                                              selectedVariants
                                                                  .add(ind);
                                                            });
                                                          }
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius
                                                                        .circular(
                                                                            5.0)),
                                                            border: Border.all(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        193,
                                                                        193,
                                                                        193,
                                                                        1)),
                                                            color: selectedVariants
                                                                        .indexOf(
                                                                            ind) !=
                                                                    -1
                                                                ? Color.fromRGBO(
                                                                    25,
                                                                    112,
                                                                    80,
                                                                    1)
                                                                : Colors.white,
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        8.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          18.0),
                                                                  child:
                                                                      Container(
                                                                    //color: Colors.red,
                                                                    width: (MediaQuery.of(context)
                                                                                .size
                                                                                .width /
                                                                            2) +
                                                                        30,
                                                                    child: Text(
                                                                      banks[i].variants![
                                                                              ind] +
                                                                          " Credit Card",
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style:
                                                                          TextStyle(
                                                                        color: selectedVariants.indexOf(ind) !=
                                                                                -1
                                                                            ? Colors
                                                                                .white
                                                                            : Color.fromRGBO(
                                                                                104,
                                                                                132,
                                                                                95,
                                                                                0.75),
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        fontSize:
                                                                            20,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                AnimatedContainer(
                                                                  curve: Curves
                                                                      .fastOutSlowIn,
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                          300),
                                                                  height:
                                                                      selectedVariants.indexOf(ind) !=
                                                                              -1
                                                                          ? 30
                                                                          : 0,
                                                                  width: selectedVariants
                                                                              .indexOf(ind) !=
                                                                          -1
                                                                      ? 30
                                                                      : 0,
                                                                  child: selectedVariants
                                                                              .indexOf(ind) !=
                                                                          -1
                                                                      ? Icon(
                                                                          Icons
                                                                              .check_circle,
                                                                          color: Colors
                                                                              .white,
                                                                        )
                                                                      : null,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                            );
                                          } else
                                            return Container();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return Container();
                  },
                )),
            Builder(
              builder: (context) {
                if (selectedBank != -1) {
                  return GestureDetector(
                      onTap: () async {
                        if (selectedVariants.length == 0)
                          return;
                        else {
                          List<Offer> offers = await getOffers() ?? [];
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              contentPadding: EdgeInsets.all(20),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(22.0))
                              ),
                              title: Text(
                                "Here are your deals!",
                                style: TextStyle(
                                  color: Color.fromRGBO(104, 132, 95, 1),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                ),
                              ),
                              content: Container(
                                width: MediaQuery.of(context).size.width - 20,
                                height: MediaQuery.of(context).size.height - 300,
                                child: ListView.builder(
                                  shrinkWrap: true,
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
                                                  Navigator.of(context).pop();
                                                  await AuthService().recentOffers(offers[i]);
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
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      child: Container(
                        height: 70,
                        decoration: BoxDecoration(
                          color: selectedVariants.length != 0
                              ? Color.fromRGBO(25, 112, 80, 1)
                              : Color.fromRGBO(196, 196, 196, 1),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Text(
                            "View Available Offers",
                            style: TextStyle(
                              color: selectedVariants.length == 0
                                  ? Color.fromRGBO(142, 142, 142, 1)
                                  : Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ));
                } else
                  return Container();
              },
            )
          ],
        ),
      ),
    );
  }
}
