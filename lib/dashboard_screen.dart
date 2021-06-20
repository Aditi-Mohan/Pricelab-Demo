import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import 'bank_screen.dart';
import 'utils/showup_animation.dart';
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
          ShowUp(
            delay: Duration(milliseconds: 500),
            child: Container(
              height: 18*3,
              //color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 18.0, 0, 0),
                child: Text(
                  "Press and Hold to Delete",
                  style: TextStyle(
                    color: Color.fromRGBO(104, 132, 95, 1),
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
          ShowUp(
            delay: Duration(milliseconds: 500),
            child: Container(
                height: MediaQuery.of(context).size.height - 100 - (18*3),
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
                                      showDialog(context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text("View: "),
                                        content: Container(
                                          width: MediaQuery.of(context).size.width - 20,
                                          height: 70,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              ElevatedButton(
                                                  style: ButtonStyle(
                                                    backgroundColor: MaterialStateColor.resolveWith((states) => Color.fromRGBO(25, 112, 80, 1)),
                                                  ),
                                                  onPressed: ()  {
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).push(
                                                        PageRouteBuilder(
                                                            transitionDuration: Duration(milliseconds: 700),
                                                            pageBuilder: (_,__,___) => BankScreen(bank: banks[i].id, offers: false,)
                                                        )
                                                    );
                                                  },
                                                  child: Container(
                                                    child: Padding(
                                                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                                      child: Text("Variants",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                              ),
                                              ElevatedButton(
                                                  style: ButtonStyle(
                                                    backgroundColor: MaterialStateColor.resolveWith((states) => Color.fromRGBO(25, 112, 80, 1)),
                                                  ),
                                                  onPressed: ()  {
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).push(
                                                        PageRouteBuilder(
                                                            transitionDuration: Duration(milliseconds: 700),
                                                            pageBuilder: (_,__,___) => BankScreen(bank: banks[i].id, offers: true,)
                                                        )
                                                    );
                                                  },
                                                  child: Container(
                                                    child: Padding(
                                                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                                      child: Text("Offers",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                              )
                                            ],
                                          ),
                                        ),
                                      ));
                                    },
                                    onLongPress: () {
                                      showDialog(context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text(banks[i].id+" Bank"),
                                            content: Text("Are you sure you want to Delete this Bank?"),
                                            actions: [
                                              ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor: MaterialStateColor.resolveWith((states) => Color.fromRGBO(196, 196, 196, 1)),
                                                ),
                                                child: Container(
                                                  child: Padding(
                                                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                                    child: Text("CANCEL",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w400,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor: MaterialStateColor.resolveWith((states) => Colors.red),
                                                ),
                                                child: Container(
                                                  child: Padding(
                                                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                                    child: Text("DELETE",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w400,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  String bank = banks[i].id;
                                                  print(bank);
                                                  String url = "https://us-central1-pricelabdemo.cloudfunctions.net/banks/"+bank;
                                                  http.Response res = await http.delete(Uri.parse(url));
                                                  if(res.statusCode != 200)
                                                    print(res);
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
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
                                                Material(
                                                  type: MaterialType.transparency,
                                                  child: Text((banks[i].data()! as Map)["variants"].length.toString()+" Card"+((banks[i].data()! as Map)["variants"].length == 1 ? "" : "s"),
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(104, 132, 95, 0.75),
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 20,
                                                    ),
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
            ),
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

  bool enteredBank = false;
  String bank = "";
  List<String> newVariants = [];

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
                      )
                  )
                ],
              );
            }
            else {
              return  Column(
                children: [
                  Container(
                    height: newVariants.length < 3 ?  newVariants.length * 60 : 200 ,
                    child: ListView.builder(
                      itemCount: newVariants.length,
                      itemBuilder: (context, i) {
                        return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 40,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                                  border: Border.all(
                                      color: Color.fromRGBO(193, 193, 193, 1)
                                  ),
                                ),
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      newVariants[i],
                                      style: TextStyle(
                                        color: Color.fromRGBO(104, 132, 95, 1),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 18,
                                      ),
                                    )
                                )
                            )
                        );
                      },
                    ),
                  ),
                  Container(height: 20,),
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
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith((states) => Color.fromRGBO(25, 112, 80, 1)),
                      ),
                      onPressed:() {
                        if(_controller.value.text != "") {
                          setState((){
                            newVariants.add(_controller.value.text);
                            _controller.text = "";
                          });
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
                    ),
                  ),
                  Container(height: 20,),
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith((states) => Color.fromRGBO(25, 112, 80, 1)),
                      ),
                      onPressed: () async {
                        if(_controller.value.text != "") {
                          newVariants.add(_controller.value.text);
                        }
                        String body = json.encode({
                          "bank": bank,
                          "variants": newVariants,
                        });
                        print(body);
                        http.Response res = await http.post(
                            Uri.parse("https://us-central1-pricelabdemo.cloudfunctions.net/banks/addBank"),
                            headers: <String, String>{
                              'Content-Type': 'application/json; charset=UTF-8',
                            },
                            body: body
                        );
                        if(res.statusCode == 201)
                          Navigator.of(context).pop();
                        else
                          print(res.statusCode);
                      },
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Text("Finish",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      )
                  )
                ],
              );
            }
          },
        )
    );
  }
}
