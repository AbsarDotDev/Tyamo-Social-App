import 'package:ecometsy/Utils/utils.dart';
import 'package:ecometsy/ui/posts_wtih_realtime/post_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  const OtpScreen({super.key, required this.verificationId});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final auth = FirebaseAuth.instance;
  final TextEditingController otp1 = new TextEditingController();
  void verifyOTP(String code) async {
    final credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId, smsCode: code);
    try {
      await auth.signInWithCredential(credential);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Post(),
          ));
    } catch (e) {
      Utils().showToastMessage(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 80,
            ),
            OtpTextField(
              numberOfFields: 6,
              borderColor: Color(0xFF512DA8),
              //set to true to show as box or false to show as dash
              showFieldAsBox: true,

              //runs when every textfield is filled
              onSubmit: (String verificationCode) {
                verifyOTP(verificationCode);
              }, // end onSubmit
            ),
          ],
        ),
      ),
    );
  }
}
