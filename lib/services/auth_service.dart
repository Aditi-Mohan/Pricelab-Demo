import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  late String message;

  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if(googleSignInAccount == null) throw("Account not found");
      final GoogleSignInAuthentication? googleSignInAuthentication = await googleSignInAccount.authentication;
      if(googleSignInAuthentication == null) throw("Unable to Authenticate");
      final AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );
      final UserCredential response = await _firebaseAuth.signInWithCredential(authCredential);
      if(response.user == null) throw("Could Not SignIn");
      final User? user = response.user;
      return true;
      //TODO: save user
    }
    catch(err) {
      print("Error: $err");
      message = err.toString();
      return false;
    }
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