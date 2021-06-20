import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'utils/showup_animation.dart';

class BankScreen extends StatefulWidget {
  final String bank;
  bool offers;

  BankScreen({required this.bank, required this.offers});

  @override
  _BankScreenState createState() => _BankScreenState();
}

class _BankScreenState extends State<BankScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String filterVariant = "";

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        if(filterVariant != "") {
          setState(() {
            filterVariant = "";
            widget.offers = false;
          });
          return false;
        }
        else return true;
      },
      child: Scaffold(
        body: Column(children: [
          Hero(
            tag: widget.bank,
            child: Container(
              color: Color.fromRGBO(25, 112, 80, 1),
              height: 100,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 50, 0, 0),
                    child: Material(
                      type: MaterialType.transparency,
                      child: Text(
                        widget.bank + (widget.offers ? " Offers" : " Variants"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 26,
                        ),
                      ),
                    ),
                  ),
                  Builder(
                    builder: (context) {
                      if (filterVariant != "" && widget.offers) {
                        return Padding(
                            padding: const EdgeInsets.fromLTRB(0, 50, 20, 0),
                            child: Material(
                                type: MaterialType.transparency,
                                child: Icon(Icons.sort, color: Colors.white, size: 26,),
                            )
                        );
                      }
                      else return Container();
                    },
                  )
                ],
              ),
            ),
          ),
          ShowUp(
            delay: Duration(milliseconds: 500),
            child: Container(
              height: !widget.offers ? 18*5 : 18*3,
              //color: Colors.red,
              child: Column(
                children: [
                  Padding(
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
                  Builder(
                    builder: (context) {
                      if(!widget.offers) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 10),
                          child: Text(
                            "or Tap to view Offers for a Variant",
                            style: TextStyle(
                              color: Color.fromRGBO(104, 132, 95, 1),
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                            ),
                          ),
                        );
                      }
                      else return Container();
                    },
                  )
                ],
              ),
            ),
          ),
          Builder(
            builder: (context) {
              if(!widget.offers) {
                return ShowUp(
                  delay: Duration(milliseconds: 500),
                  child: Container(
                      height: MediaQuery.of(context).size.height - 100 - (18*5),
                      child: StreamBuilder(
                        stream: _firestore.collection("banks").doc(widget.bank).snapshots(),
                        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                          print(snapshot.hasData);
                          if(snapshot.hasData) {
                            var data = snapshot.data!.data() as Map;
                            return ListView.builder(
                              itemCount: data["variants"].length+1,
                              itemBuilder: (context, i) {
                                if(i == data["variants"].length) {
                                  return GestureDetector(
                                    onTap: () {
                                      showDialog(context: context,
                                          barrierDismissible: false,
                                          builder: (context) => AlertDialog(
                                            content: AddVariantDialog(bank: widget.bank),
                                          )
                                      );
                                    },
                                    child: Container(
                                      height: 70,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("Add Variants",
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
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          filterVariant = data["variants"][i];
                                          widget.offers = true;
                                        });
                                      },
                                      onLongPress: () {
                                        print(data["variants"][i]);
                                        showDialog(context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text(data["variants"][i]+" Credit Card"),
                                            content: Text("Are you sure you want to Delete this Variant?"),
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
                                                  String variant = data["variants"][i];
                                                  print(variant);
                                                  String url = "https://us-central1-pricelabdemo.cloudfunctions.net/banks/"+widget.bank+"/"+variant;
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
                                                      child: Text(data["variants"][i]+" Card",
                                                        style: TextStyle(
                                                          color: Color.fromRGBO(104, 132, 95, 1),
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ),
                                                    FutureBuilder(
                                                      future: _firestore.collection("banks").doc(widget.bank).collection("offers").get(),
                                                      builder: (context, AsyncSnapshot<QuerySnapshot> snap) {
                                                        if(snap.connectionState == ConnectionState.done) {
                                                          int nums = 0;
                                                          snap.data!.docs.forEach((element) {
                                                            print((element.data() as Map)["variant"]);
                                                            if((element.data() as Map)["variant"] == data["variants"][i])
                                                              nums++;
                                                          });
                                                          return Text(nums.toString()+ " Offer"+(nums == 1 ? "" : "s"),
                                                            style: TextStyle(
                                                              color: Color.fromRGBO(104, 132, 95, 1),
                                                              fontWeight: FontWeight.w400,
                                                              fontSize: 18,
                                                            ),
                                                          );
                                                        }
                                                        else return Container();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                  ],
                                                ),
                                            ),
                                          ),
                                    )
                                  );
                                }
                              },
                            );
                          }
                          else return Container();
                        },
                      )
                  ),
                );
              }
              else {
                return ShowUp(
                  delay: Duration(milliseconds: 500),
                  child: Container(
                      height: MediaQuery.of(context).size.height - 100 - (18*3),
                      child: StreamBuilder(
                        stream: filterVariant == "" ? _firestore.collection("banks").doc(widget.bank).collection("offers").snapshots() : _firestore.collection("banks").doc(widget.bank).collection("offers").where("variant", isEqualTo: filterVariant).snapshots(),
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
                                      showDialog(context: context,
                                          barrierDismissible: false,
                                          builder: (context) => AlertDialog(
                                            content: AddOfferDialog(bank: widget.bank, filterVariant: filterVariant == "" ? null : filterVariant,),
                                          )
                                      );
                                    },
                                    child: Container(
                                      height: 70,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("Add Offer",
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
                                    child: GestureDetector(
                                      onLongPress: () {
                                        print((docs[i].data() as Map)["title"]);
                                        showDialog(context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text((docs[i].data() as Map)["title"]),
                                            content: Text("Are you sure you want to Delete this Offer?"),
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
                                                  String promoCode = (docs[i].data() as Map)["promoCode"];
                                                  print(promoCode);
                                                  String url = "https://us-central1-pricelabdemo.cloudfunctions.net/banks/"+widget.bank+"/offer/"+promoCode;
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
                                                    Column(
                                                      children: [
                                                        Container(
                                                          width: (MediaQuery.of(context).size.width/2),
                                                          child: Text((docs[i].data() as Map)["title"],
                                                            style: TextStyle(
                                                              color: Color.fromRGBO(104, 132, 95, 1),
                                                              fontWeight: FontWeight.w400,
                                                              fontSize: 18,
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
                                                            child: Center(
                                                              child: Text((docs[i].data() as Map)["promoCode"],
                                                                style: TextStyle(
                                                                  color: Color.fromRGBO(104, 132, 95, 0.75),
                                                                  fontWeight: FontWeight.w600,
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            )
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                Container(height: 10,),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Material(
                                                      type: MaterialType.transparency,
                                                      child: Text("For "+(docs[i].data() as Map)["variant"]+" Credit Card",
                                                        style: TextStyle(
                                                          color: Color.fromRGBO(104, 132, 95, 0.75),
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                      ),
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
                );
              }
            },
          ),
        ]),
      ),
    );
  }
}

class AddVariantDialog extends StatefulWidget {
  final String bank;

  AddVariantDialog({required this.bank});

  @override
  _AddVariantDialogState createState() => _AddVariantDialogState();
}

class _AddVariantDialogState extends State<AddVariantDialog> {
  TextEditingController _controller = TextEditingController();
  List<String> newVariants = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      height: MediaQuery.of(context).size.height - 300,
      child: Column(
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
                  "newVariants": newVariants,
                });
                print(body);
                String url = "https://us-central1-pricelabdemo.cloudfunctions.net/banks/"+widget.bank+"/addVariants";
                http.Response res = await http.put(
                    Uri.parse(url),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: body
                );
                if(res.statusCode == 204)
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
      ),
    );
  }
}

class AddOfferDialog extends StatefulWidget {
  final String bank;
  final String? filterVariant;

  AddOfferDialog({required this.bank, this.filterVariant});

  @override
  _AddOfferDialogState createState() => _AddOfferDialogState();
}

class _AddOfferDialogState extends State<AddOfferDialog> {
  TextEditingController _controller = TextEditingController();
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if(widget.filterVariant != null) {
      _controller1.text = widget.filterVariant!;
    }
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      height: MediaQuery.of(context).size.height - 300,
      child: Column(
        children: [
          Text("Offer:",
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
          Text("Variant Name:",
            style: TextStyle(
              color: Color.fromRGBO(104, 132, 95, 0.75),
              fontWeight: FontWeight.w400,
              fontSize: 20,
            ),
          ),
          TextField(
            controller: _controller1,
            readOnly: widget.filterVariant != null,
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
                  String body = json.encode({
                    "newOffers": [
                      {"title": _controller.value.text, "variant": _controller1.value.text, "promoCode": _controller2.value.text}
                    ],
                  });
                  String url = "https://us-central1-pricelabdemo.cloudfunctions.net/banks/"+widget.bank+"/addOffers";
                  print(body);
                  http.Response res = await http.put(
                      Uri.parse(url),
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                      },
                      body: body
                  );
                  if(res.statusCode == 204)
                    Navigator.of(context).pop();
                  else
                    print(res.statusCode);
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
    );
  }
}
