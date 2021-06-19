import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '/models/offer.dart';
import '/models/user.dart';

UserRepo _userRepo = UserRepo();

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  late String message;

  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if(googleSignInAccount == null) throw("Account not found!");
      final GoogleSignInAuthentication? googleSignInAuthentication = await googleSignInAccount.authentication;
      if(googleSignInAuthentication == null) throw("Unable to Authenticate!");
      final AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );
      final UserCredential response = await _firebaseAuth.signInWithCredential(authCredential);
      if(response.user == null) throw("Could Not SignIn!");
      final User? user = response.user;
      _userRepo = UserRepo(uid: user!.uid.toString());
      message = "Signed In as "+user.displayName.toString()+" !";
      //print(user!.uid.toString());
      return true;
    }
    catch(err) {
      print("Error: $err");
      message = err.toString();
      return false;
    }
  }

  Future<bool> userExists() async {
    return await _firestore.collection('users').doc(_userRepo.uid).get().then((value) => value.exists);
  }

  Future<void> recentOffers(Offer offer) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(_userRepo.uid).get();
    if(doc.exists) {
      bool alreadyExists = false;
      ((doc.data() as Map)["recentOffers"] as List<dynamic>).forEach((element) {
        if(element["offer"] == offer.title)
          alreadyExists = true;
      });
      if(alreadyExists)
        return;
      _firestore.collection('users').doc(_userRepo.uid).update({
        "recentOffers": (doc.data() as Map)["recentOffers"] + [{"offer": offer.title, "description": offer.description, "promoCode": offer.promoCode}]});
    }
    else {
      await _firestore.collection('users').doc(_userRepo.uid).set(
        {
          "recentOffers": [{"offer": offer.title,
            "description": offer.description,
            "promoCode": offer.promoCode,}]
        }
      );
    }
  }

  Future<List<Offer>> getRecentOffers() async {
    List<Offer> offers = [];
    DocumentSnapshot doc = await _firestore.collection('users').doc(_userRepo.uid).get();
    List<dynamic> rf = (doc.data() as Map)["recentOffers"]  as List<dynamic>;
    rf.forEach((element) {
      Offer o = Offer(title: element["offer"], description: element["description"], promoCode: element["promoCode"]);
      offers.add(o);
    });
    return offers;
  }

  Future<bool> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch (err) {
      print('Error: $err');
      message = err.toString();
      return false;
    }
  }
}