import 'package:ecometsy/Utils/utils.dart';
import 'package:ecometsy/Widgets/round_button.dart';
import 'package:ecometsy/ui/auth/otp_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class LoginWithPhone extends StatefulWidget {
  const LoginWithPhone({super.key});

  @override
  State<LoginWithPhone> createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends State<LoginWithPhone> {
  bool isLoading = false;
  PhoneNumber phone =
      PhoneNumber(countryISOCode: 'PK', countryCode: '+92', number: '');
  final auth = FirebaseAuth.instance;
  void loginWithPhone() {
    setState(() {
      isLoading = true;
    });

    auth.verifyPhoneNumber(
        phoneNumber: phone.countryCode + phone.number,
        verificationCompleted: (phoneAuthCredential) async {
          setState(() {
            isLoading = false;
          });
          //signInWithPhoneAuthCredential(phoneAuthCredential);
        },
        verificationFailed: (verificationFailed) async {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(verificationFailed.message.toString()),
            ),
          );
        },
        codeSent: (verificationId, resendingToken) async {
          setState(() {
            isLoading = false;
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpScreen(
                  verificationId: verificationId,
                ),
              ));
        },
        codeAutoRetrievalTimeout: (verificationId) async {
          setState(() {
            isLoading = false;
          });
          Utils().showToastMessage(
              'Auto retrieval time out, please try again later');
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login with phone'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 80,
            ),
            IntlPhoneField(
              flagsButtonPadding: const EdgeInsets.only(left: 14),
              dropdownTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w700),
              showDropdownIcon: false,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 67),
                filled: true,
                hintText: '123 2344',
                hintStyle: const TextStyle(
                  fontFamily: "spartan",
                  fontWeight: FontWeight.w700,
                  color: Color(0xff858891),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              initialCountryCode: 'PK',
              showCountryFlag: true,
              onChanged: (phone) {
                setState(() {
                  this.phone = phone;
                });
              },
            ),
            SizedBox(height: 50),
            RoundButton(
              title: 'Login',
              loading: isLoading,
              ontap: () {
                loginWithPhone();
              },
            ),
          ],
        ),
      ),
    );
  }
}
