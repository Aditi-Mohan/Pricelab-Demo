import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pricelabdemo/bank_screen.dart';
import 'package:http/http.dart' as http;

import 'models/bank.dart';

class DashBoardScreen extends StatefulWidget {
  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Bank> banks = [];
  bool loaded = false;

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
                  stream: _firestore.collection("banks").snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      List<DocumentSnapshot> banks = snapshot.data!.docs;
                      return ListView.builder(
                          itemCount: banks.length + 1,
                          itemBuilder: (context, i) {
                            if (i == banks.length) {
                              return GestureDetector(
                                onTap: () {
                                  showDialog(context: context,
                                    barrierDismissible: false,
                                    builder: (context) => AlertDialog(
                                      content: DialogBody(),
                                    )
                                  );
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
                                  onTap: () {
                                    Navigator.of(context).push(
                                        PageRouteBuilder(
                                            transitionDuration: Duration(milliseconds: 700),
                                            pageBuilder: (_,__,___) => BankScreen(bank: banks[i].id)
                                        )
                                    );
                                  },
                                  child: Hero(
                                    tag: banks[i].id,
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
                                              Material(
                                                type: MaterialType.transparency,
                                                child: Text(banks[i].id,
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(104, 132, 95, 0.75),
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                              Text((banks[i].data()! as Map)["variants"].length.toString(),
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

class DialogBody extends StatefulWidget {
  @override
  _DialogBodyState createState() => _DialogBodyState();
}

class _DialogBodyState extends State<DialogBody> {
  TextEditingController _controller = TextEditingController();
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  bool enteredBank = false;
  String bank = "";
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width - 20,
        height: MediaQuery.of(context).size.height - 300,
        child: Builder(
          builder: (context) {
            if(!enteredBank) {
              return Column(
                children: [
                  Text("Bank Name:",
                    style: TextStyle(
                      color: Color.fromRGBO(104, 132, 95, 0.75),
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                  TextField(
                    controller: _controller,
                  ),
                  Container(height: 20,),
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith((states) => Color.fromRGBO(25, 112, 80, 1)),
                      ),
                      onPressed: () async {
                        if (_controller.value.text != "") {
                          setState(() {
                            bank = _controller.value.text;
                            enteredBank = true;
                            _controller.text = "";
                          });
                        }
                      },
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Text("Next",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ))
                ],
              );
            }
            else {
              return  Column(
                children: [
                  Text("Variant Name:",
                    style: TextStyle(
                      color: Color.fromRGBO(104, 132, 95, 0.75),
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                  TextField(
                    controller: _controller,
                  ),
                  Container(height: 20,),
                  Text("Offer:",
                    style: TextStyle(
                      color: Color.fromRGBO(104, 132, 95, 0.75),
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                  TextField(
                    controller: _controller1,
                  ),
                  Container(height: 20,),
                  Text("PromoCode:",
                    style: TextStyle(
                      color: Color.fromRGBO(104, 132, 95, 0.75),
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                  TextField(
                    controller: _controller2,
                  ),
                  Container(height: 20,),
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith((states) => Color.fromRGBO(25, 112, 80, 1)),
                      ),
                      onPressed: () async {
                        if (_controller.value.text != "" || _controller1.value.text != "" || _controller2.value.text != "") {
                          Map<String, String> details = {"variant": _controller.value.text, "offer": _controller1.value.text, "promoCode": _controller2.value.text};
                          print(bank);
                          print(details["variant"]);
                          print(details["offer"]);
                          print(details["promoCode"]);
                          String body = json.encode({
                            "bank": bank,
                            "details": [
                              {"variant": _controller.value.text, "offer": _controller1.value.text, "promoCode": _controller2.value.text}
                              ],
                          });
                          print(body);
//                          http.Response res = await http.post(
//                              Uri.parse("https://us-central1-pricelabdemo.cloudfunctions.net/banks/addBank"),
//                            headers: <String, String>{
//                              'Content-Type': 'application/json; charset=UTF-8',
//                            },
//                            body: body
//                          );
//                          if(res.statusCode == 201)
//                            Navigator.of(context).pop();
//                          else
//                            print(res.statusCode);
                        }
                      },
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Text("Add",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ))
                ],
              );
            }
          },
        )
    );
  }
}
