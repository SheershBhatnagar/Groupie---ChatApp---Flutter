
import 'package:flutter/material.dart';
import 'package:groupie/pages/home_page.dart';

import 'package:groupie/shared/constants.dart';

import 'auth/login_page.dart';

import '../helper/helper_function.dart';
import '../services/auth_service.dart';
import '../widgets/widgets.dart';

class ProfilePage extends StatefulWidget {

  String userName;
  String email;

  ProfilePage({
    super.key,
    required this.userName,
    required this.email,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants().primaryColor,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 27,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
          vertical: 170,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.account_circle,
              size: 200,
              color: Colors.grey[700],
            ),
            const SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Full Name",
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
                Text(
                  widget.userName,
                  style: const TextStyle(
                    fontSize: 17,
                  ),
                ),
              ],
            ),
            const Divider(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Email",
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
                Text(
                  widget.email,
                  style: const TextStyle(
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            vertical: 50,
          ),
          children: [
            Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.grey[700],
            ),
            const SizedBox(height: 15,),
            Text(
              widget.userName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 5,),
            Text(
              widget.email,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 30,),
            const Divider(
              height: 2,
            ),
            ListTile(
              onTap: () {
                nextScreen(context, const HomePage());
              },
              title: const Text(
                "Groups",
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 5,
              ),
              leading: const Icon(Icons.group),
            ),
            ListTile(
              title: const Text(
                "Profile",
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 5,
              ),
              selectedColor: Constants().primaryColor,
              selected: true,
              leading: const Icon(Icons.person),
            ),
            ListTile(
              onTap: () async {
                showDialog(context: context, builder: (context){
                  return AlertDialog(
                    content: const Text(
                      "Are you sure you want to logout?",
                    ),
                    title: const Text(
                      "Logout",
                    ),
                    actions: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.cancel,
                          color: Colors.red,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await authService.signOut().whenComplete(() {
                            nextScreenReplace(context, const LoginPage());
                          });
                        },
                        icon: const Icon(
                          Icons.exit_to_app,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  );
                });
              },
              title: const Text(
                "Logout",
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 5,
              ),
              leading: const Icon(Icons.exit_to_app),
            ),
          ],
        ),
      ),
    );
  }
}
