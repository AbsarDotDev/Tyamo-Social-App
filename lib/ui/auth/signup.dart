import 'package:ecometsy/Widgets/round_button.dart';
import 'package:ecometsy/ui/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool loading = false;
  final _formKey =
      GlobalKey<FormState>(); //to validate whether the field is empty or not
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  FirebaseAuth _auth =
      FirebaseAuth.instance; //fire base auth ka object utha rhe for usage
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController
        .dispose(); //to remove from memory after closing of screen
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup screeeen'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            hintText: 'Email',
                            helperText: 'bakhtiar@gmail.com',
                            prefixIcon: Icon(Icons.email)),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter email';
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                              hintText: 'Password',
                              prefixIcon: Icon(Icons.lock)),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter password';
                            } else {
                              return null;
                            }
                          }),
                    ],
                  )),
              SizedBox(
                height: 20,
              ),
              RoundButton(
                title: 'Sign Up',
                loading: loading,
                ontap: () {
                  // if (_formKey.currentState!.validate()) {
                  //   setState(() {
                  //     loading = true; //jb button tap ho tou loading hogi
                  //   });
                  //   _auth
                  //       .createUserWithEmailAndPassword(
                  //           email: emailController.text.toString(),
                  //           password: passwordController.text.toString())
                  //       .then((value) {
                  //     setState(() {
                  //       loading = false; //hojaye tou loader nhi show hoga
                  //     });
                  //   }).onError((error, stackTrace) {
                  //     Utils().toastMessage(error.toString());
                  //     setState(() {
                  //       loading =
                  //           false; //jb error throw hoga tou loader stop hojaega
                  //     });
                  //   });
                  // }
                },
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account'),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ));
                      },
                      child: Text(
                        'Login ',
                        style: TextStyle(decoration: TextDecoration.underline),
                      ))
                ],
              )
            ]),
      ),
    );
  }
}
