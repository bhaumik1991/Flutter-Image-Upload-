import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GoogleSignInProvider extends ChangeNotifier{
  final googleSignIn = GoogleSignIn();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  bool _isSigningIn;


  GoogleSignInProvider(){
    _isSigningIn = false;
  }

  bool get isSigningIn => _isSigningIn;

  set isSigningIn(bool isSigningIn){
    _isSigningIn = isSigningIn;
    notifyListeners();
  }

  Future login() async{
    isSigningIn = false;

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    if(googleSignInAccount == null){
      isSigningIn = false;
      return;
    }else{
      GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken
      );

      final UserCredential authResult =  await FirebaseAuth.instance.signInWithCredential(credential);

      final User user = authResult.user;

      var userData = {
        "name" : googleSignInAccount.displayName,
        "provider" : "google",
        "email" : googleSignInAccount.email,
        "photoUrl" : googleSignInAccount.photoUrl
      };

      users.doc(user.uid).get().then((doc) {
        if(doc.exists){
          doc.reference.update(userData);
        }else{
          users.doc(user.uid).set(userData);
        }
      });

      isSigningIn = false;
    }

  }

  void logout() async{
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}