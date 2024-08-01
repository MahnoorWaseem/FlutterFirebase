import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/ui/firebase_list.dart';
import 'package:first_app/auth/loginSceen.dart';
import 'package:first_app/firestore/firestoreListScreen.dart';
import 'package:first_app/posts/postScreen.dart';
import 'package:flutter/material.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser; //return currentlu signed in user

    if(user==null){
       Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen())); 
    });
    }else{
       Timer(Duration(seconds: 3), () {
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => PostScreen())); //for firebase real time data base

          Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => FirestoreListScreen())); //for firebase firestore base
    });
    }

  }
}
