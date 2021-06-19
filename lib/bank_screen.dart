import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'utils/showup_animation.dart';

class BankScreen extends StatefulWidget {
  final String bank;

  BankScreen({required this.bank});

  @override
  _BankScreenState createState() => _BankScreenState();
}

class _BankScreenState extends State<BankScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    print("called");
    return Scaffold(
      body: Column(children: [
        Hero(
          tag: widget.bank,
          child: Container(
            color: Color.fromRGBO(25, 112, 80, 1),
            height: 100,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: Material(
                type: MaterialType.transparency,
                child: Text(
                  widget.bank,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 26,
                  ),
                ),
              ),
            ),
          ),
        ),
        ShowUp(
          delay: Duration(milliseconds: 500),
          child: Container(
            height: MediaQuery.of(context).size.height - 100,
            child: StreamBuilder(
              stream: _firestore.collection("offers").doc(widget.bank).collection("variants").snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                print(snapshot.hasData);
                if(snapshot.hasData) {
                  List<DocumentSnapshot> docs = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: docs.length+1,
                    itemBuilder: (context, i) {
                      if(i == docs.length) {
                        return GestureDetector(
                          onTap: () {
                            TextEditingController _controller = TextEditingController();
                            TextEditingController _controller1 = TextEditingController();
                            TextEditingController _controller2 = TextEditingController();
                            showDialog(context: context,
                                barrierDismissible: false,
                                builder: (context) => AlertDialog(
                                  content: Container(
                                    width: MediaQuery.of(context).size.width - 20,
                                    height: MediaQuery.of(context).size.height - 300,
                                    child: Column(
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
                                              if (_controller.value.text != "") {
                                                Map<String, String> details = {"variant": _controller.value.text, "offer": _controller1.value.text, "promoCode": _controller2.value.text};
                                                print(widget.bank);
                                                print(details["variant"]);
                                                print(details["offer"]);
                                                print(details["promoCode"]);
                                                String body = json.encode({
                                                  "newVariants": [
                                                    {"variant": _controller.value.text, "offer": _controller1.value.text, "promoCode": _controller2.value.text}
                                                  ],
                                                });
                                                String url = "https://us-central1-pricelabdemo.cloudfunctions.net/banks/"+widget.bank+"/addVariants";
                                                print(body);
//                                                http.Response res = await http.post(
//                                                    Uri.parse(url),
//                                                    headers: <String, String>{
//                                                      'Content-Type': 'application/json; charset=UTF-8',
//                                                    },
//                                                    body: body
//                                                );
//                                                if(res.statusCode == 201)
//                                                  Navigator.of(context).pop();
//                                                else
//                                                  print(res.statusCode);
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
                                    ),
                                  ),
                                )
                            );
                          },
                          child: Container(
                            height: 70,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Add Variant",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20,
                                    color: Colors.black
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Material(
                                          type: MaterialType.transparency,
                                          child: Text(docs[i].id,
                                            style: TextStyle(
                                              color: Color.fromRGBO(104, 132, 95, 1),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(height: 10,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              width: (MediaQuery.of(context).size.width/2),
                                              child: Text((docs[i].data() as Map)["offer"] ?? "No Offer",
                                                style: TextStyle(
                                                  color: Color.fromRGBO(104, 132, 95, 0.75),
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context).size.width/3,
                                                child: Text((docs[i].data() as Map)["promoCode"] ?? "",
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(104, 132, 95, 0.75),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                  ),
                                                )
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )
                          ),
                        );
                      }
                    },
                  );
                }
                else return Container();
              },
            )
          ),
        ),
      ]),
    );
  }
}
