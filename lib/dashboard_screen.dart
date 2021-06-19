import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/bank.dart';

class DashBoardScreen extends StatefulWidget {
  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Bank> banks = [];
  bool loaded = false;

  Future<void> getBanksAndVar(DocumentSnapshot doc) async {
    try {
      if (doc.data() == null) throw ("Doc empty");
      List<String> vars = [...(doc.data() as Map)['variants']];
      Bank b = Bank(name: doc.id, variants: vars);
      banks.add(b);
    } catch (err) {
      print("Error: $err");
      return null;
    }
  }

  Future<void> _showPopup(Bank b) async {
    showDialog(context: context,
      builder: (context) => AlertDialog(
        content: StreamBuilder(
          stream: _firestore.collection("offers").doc(b.name).collection("variants").snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData)
              return Container();
            else {

              return Container(
                width: MediaQuery.of(context).size.width - 20,
                height: MediaQuery.of(context).size.height - 300,
//                child: ListView.builder(
//                  itemCount: ,
//                  itemBuilder: (context, i) {
//
//                  },
//                ),
              );
            }
          },
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Color.fromRGBO(25, 112, 80, 1),
            height: 100,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 60, 0, 18.0),
              child: Text("Banks",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 26,
                ),
              ),
            ),
          ),
          Container(
              height: MediaQuery.of(context).size.height - 100,
              child: StreamBuilder(
                  stream: _firestore.collection("offers").snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      banks = [];
                      snapshot.data!.docs.forEach(getBanksAndVar);
                      return ListView.builder(
                          itemCount: banks.length + 1,
                          itemBuilder: (context, i) {
                            if (i == banks.length) {
                              return GestureDetector(
                                onTap: () {
                                  _showPopup(banks[i]);
                                },
                                child: Container(
                                  height: 70,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Add Bank",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Icon(Icons.add)
                                    ],
                                  ),
                                ),
                              );
                            }
                            else {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                        border: Border.all(
                                            color: Color.fromRGBO(193, 193, 193, 1)
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(banks[i].name,
                                              style: TextStyle(
                                                color: Color.fromRGBO(104, 132, 95, 0.75),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 20,
                                              ),
                                            ),
                                            Text(banks[i].variants!.length.toString(),
                                              style: TextStyle(
                                                color: Color.fromRGBO(104, 132, 95, 0.75),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 20,
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                            ),
                                ),
                              );
                          }
                          }
                      );
                    }
                    else {
                      return Container();
                    }
                  }
              )
          )
        ],
      ),
    );
  }
}
