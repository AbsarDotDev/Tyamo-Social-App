import 'dart:async';

import 'package:ecometsy/ui/auth/login.dart';
import 'package:ecometsy/ui/posts_wtih_firestore/post_screen.dart';
import 'package:ecometsy/ui/posts_wtih_realtime/post_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashServices {
  void IsLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user != null) {
      Timer(const Duration(seconds: 3), () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostFireStore(),
            ));
      });
    } else {
      Timer(const Duration(seconds: 3), () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ));
      });
    }
  }
}
