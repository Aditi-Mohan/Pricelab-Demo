import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'utils/showup_animation.dart';
import 'models/bank.dart';

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

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
    return Scaffold(
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
                  30 - (26 * 2) - 90 - 30 - 30 - (selectedBank != -1 ? 53 : 0),
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
                              if(selectedBank == i) {
                                setState(() {
                                  selectedBank = -1;
                                });
                              }
                              else {
                                setState(() {
                                  selectedBank = i;
                                  selectedVariants = [];
                                });
                              }
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.fastOutSlowIn,
                              height: i == selectedBank ? _selectedHeight : _height,
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
                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                        border: Border.all(color: Color.fromRGBO(193, 193, 193, 1)),
                                        color: i == selectedBank ? Color.fromRGBO(25, 112, 80, 1) : Colors.white,
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(18.0),
                                            child: Text(
                                              banks[i].name,
                                              style: TextStyle(
                                                color: i == selectedBank ? Colors.white : Color.fromRGBO(104, 132, 95, 0.75),
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
                                        if(i == selectedBank)
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                                            child: Text("Please choose your cards",
                                              style: TextStyle(
                                                color: Color.fromRGBO(104, 132, 95, 0.75),
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
                                        if(i == selectedBank) {
                                          return Container(
                                            height: 400 - 110,
                                            child: ListView.builder(
                                              physics: NeverScrollableScrollPhysics(),
                                              itemCount: banks[i].variants!.length,
                                              itemBuilder: (context, ind) {
                                                return Padding(
                                                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      int index = selectedVariants.indexOf(ind);
                                                      if(index != -1) {
                                                        setState(() {
                                                          selectedVariants.removeAt(index);
                                                        });
                                                      }
                                                      else {
                                                        setState(() {
                                                          selectedVariants.add(
                                                              ind);
                                                        });
                                                      }
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                        border: Border.all(color: Color.fromRGBO(193, 193, 193, 1)),
                                                        color: selectedVariants.indexOf(ind) != -1 ? Color.fromRGBO(25, 112, 80, 1) : Colors.white,
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.all(18.0),
                                                              child: Text(banks[i].variants![ind],
                                                                style: TextStyle(
                                                                  color: selectedVariants.indexOf(ind) != -1 ? Colors.white : Color.fromRGBO(104, 132, 95, 0.75),
                                                                  fontWeight: FontWeight.w400,
                                                                  fontSize: 20,
                                                                ),
                                                              ),
                                                            ),
                                                            AnimatedContainer(
                                                              curve: Curves.fastOutSlowIn,
                                                              duration: Duration(milliseconds: 300),
                                                              height: selectedVariants.indexOf(ind) != -1 ? 30 : 0,
                                                              width: selectedVariants.indexOf(ind) != -1 ? 30 : 0,
                                                              child: selectedVariants.indexOf(ind) != -1 ? Icon(Icons.check_circle, color: Colors.white,) : null,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }
                                            ),
                                          );

                                        }
                                        else
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
              )
          ),
          Builder(
            builder: (context) {
              if(selectedBank != -1) {
                return GestureDetector(
                    onTap: () async {
                      if(selectedVariants.length == 0) return;
                      else {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text("Here are your deals!",
                              style: TextStyle(
                                color: Color.fromRGBO(104, 132, 95, 1),
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                              ),
                            ),
                            content: ListView.builder(
                              itemCount: ,
                              itemBuilder: (context, i) {

                              },
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                        color: selectedVariants.length != 0 ? Color.fromRGBO(25, 112, 80, 1) : Color.fromRGBO(196, 196, 196, 1),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Text("View Available Offers",
                          style: TextStyle(
                            color: selectedVariants.length == 0 ? Color.fromRGBO(142, 142, 142, 1) : Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    )
                );
              }
              else
                return Container();
            },
          )
        ],
      ),
    );
  }
}
