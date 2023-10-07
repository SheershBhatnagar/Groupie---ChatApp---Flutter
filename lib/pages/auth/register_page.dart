
import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';

import 'package:groupie/pages/auth/login_page.dart';
import 'package:groupie/pages/home_page.dart';
import 'package:groupie/services/auth_service.dart';

import '../../helper/helper_function.dart';
import '../../shared/constants.dart';
import '../../widgets/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  bool _isLoading = false;

  final formKey = GlobalKey<FormState>();

  String fullName = "";
  String email = "";
  String password = "";

  AuthService authService = AuthService();

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
                    "Create your account now to chat & explore",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Image.asset(
                      "assets/register.png"
                  ),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    decoration: textInputDecoration.copyWith(
                      labelText: "Full Name",
                      hintText: "Enter your Full Name",
                      prefixIcon: Icon(
                        Icons.person,
                        color: Constants().primaryColor,
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        fullName = val;
                      });
                    },
                    validator: (val) {
                      if(val!.isEmpty) {
                        return "Name can not be empty!";
                      }
                      else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 15,),
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
                        email = val;
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
                        password = val;
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
                        register();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants().primaryColor,
                        elevation: 0,
                      ),
                      child: const Text(
                        "Register",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Text.rich(
                    TextSpan(
                      text: "Already have an account? ",
                      children: [
                        TextSpan(
                            text: "Login Now",
                            style: TextStyle(
                              color: Constants().primaryColor,
                            ),
                            recognizer: TapGestureRecognizer()..onTap = () {
                              nextScreen(context, LoginPage());
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

  register() async {

    if(formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await authService.registerUserWithEmailAndPassword(fullName, email, password).then((value) async {

        if(value == true) {
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(fullName);
          showSnackbar(context, Colors.green, "Registration Successful, Login!");
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
