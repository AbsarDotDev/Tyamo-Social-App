import 'dart:async';

import 'package:ecometsy/ui/auth/login.dart';
import 'package:flutter/material.dart';

class SplashServices {
  void IsLogin(BuildContext context) {
    Timer(const Duration(seconds: 3), () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ));
    });
  }
}
