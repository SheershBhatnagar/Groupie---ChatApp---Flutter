
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';

import 'package:groupie/pages/auth/register_page.dart';
import 'package:groupie/services/auth_service.dart';
import 'package:groupie/services/database_service.dart';
import 'package:groupie/shared/constants.dart';
import 'package:groupie/widgets/widgets.dart';

import '../../helper/helper_function.dart';
import '../home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  AuthService authService = AuthService();

  bool _isLoading = false;

  final formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading ? Center(
        child: CircularProgressIndicator(
          color: Constants().primaryColor,
        ),
      ) : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 80,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Groupie",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10,),
                const Text(
                  "Login now to see what they are taking!",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                Image.asset(
                  "assets/login.png"
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: textInputDecoration.copyWith(
                    labelText: "Email",
                    hintText: "Enter your email",
                    prefixIcon: Icon(
                      Icons.email_rounded,
                      color: Constants().primaryColor,
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      email = val.trim();
                    });
                  },
                  validator: (val) {
                    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(val!) ? null : "Please enter a valid email!";
                  },
                ),
                const SizedBox(height: 15,),
                TextFormField(
                  obscureText: true,
                  decoration: textInputDecoration.copyWith(
                    labelText: "Password",
                    hintText: "Enter your password",
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Constants().primaryColor,
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      password = val.trim();
                    });
                  },
                  validator: (val) {
                    if(val!.length < 8) {
                      return "Password must be at least 8 characters";
                    }
                    else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 20,),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      login();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constants().primaryColor,
                      elevation: 0,
                    ),
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Text.rich(
                  TextSpan(
                    text: "Don't have an account? ",
                    children: [
                      TextSpan(
                        text: "Register Now",
                        style: TextStyle(
                          color: Constants().primaryColor,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {
                          nextScreen(context, const RegisterPage());
                        }
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }

  login() async {

    if(formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await authService.loginUserWithEmailAndPassword(email, password).then((value) async {

        if(value == true) {

          QuerySnapshot snapshot = await DatabaseService(uid: firebaseAuth.currentUser!.uid).gettingUserData(email);

          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);
          showSnackbar(context, Colors.green, "Login Successful!");
          setState(() {
            _isLoading = false;
          });
          nextScreenReplace(context, const HomePage());
        }
        else {
          setState(() {
            _isLoading = false;
          });
          showSnackbar(context, Colors.red, value);
        }
      });
    }
  }
}
