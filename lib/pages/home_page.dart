
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:groupie/helper/helper_function.dart';
import 'package:groupie/pages/auth/login_page.dart';
import 'package:groupie/pages/profile_page.dart';
import 'package:groupie/pages/search_page.dart';
import 'package:groupie/services/auth_service.dart';
import 'package:groupie/services/database_service.dart';
import 'package:groupie/shared/constants.dart';
import 'package:groupie/widgets/group_tile.dart';
import 'package:groupie/widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  AuthService authService = AuthService();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  String userName = "";
  String email = "";
  String groupName = "";

  bool _isLoading = false;

  Stream? groups;

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_")+1);
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmailSF().then((value) {
      setState(() {
        email = value!;
      });
    });

    await HelperFunctions.getUserNameSF().then((value) {
      setState(() {
        userName = value!;
      });
    });

    await DatabaseService(uid: firebaseAuth.currentUser!.uid).getUserGroups().then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants().primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        title: const Text(
          "Groupie",
          style: TextStyle(
            color: Colors.white,
            fontSize: 27,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              nextScreen(context, const SearchPage());
            },
            icon: const Icon(
              Icons.search,
            ),
          ),
        ],
      ),
      body: groupList(),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            vertical: 50,
          ),
          children: [
            InkWell(
              onTap: () {
                nextScreen(context, ProfilePage(userName: userName, email: email,));
              },
              child: Icon(
                Icons.account_circle,
                size: 150,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 15,),
            InkWell(
              onTap: () {
                nextScreen(context, ProfilePage(userName: userName, email: email,));
              },
              child: Text(
                userName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 5,),
            InkWell(
              onTap: () {
                nextScreen(context, ProfilePage(userName: userName, email: email,));
              },
              child: Text(
                email,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 30,),
            const Divider(
              height: 2,
            ),
            ListTile(
              selectedColor: Constants().primaryColor,
              title: const Text(
                "Groups",
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 5,
              ),
              selected: true,
              leading: const Icon(Icons.group),
            ),
            ListTile(
              onTap: () {
                nextScreen(context, ProfilePage(userName: userName, email: email,));
              },
              title: const Text(
                "Profile",
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 5,
              ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialog(context);
        },
        elevation: 0,
        backgroundColor: Constants().primaryColor,
        child: const Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(context: context, builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text(
              "Create a group",
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _isLoading == true ? Center(
                  child: CircularProgressIndicator(
                    color: Constants().primaryColor,
                  ),
                ) : TextField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Constants().primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Constants().primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.red,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      groupName = val;
                    });
                  },
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if(groupName.isNotEmpty) {
                    setState(() {
                      _isLoading = true;
                    });
                    DatabaseService(uid: firebaseAuth.currentUser!.uid).createGroup(userName, firebaseAuth.currentUser!.uid, groupName).whenComplete(() {
                      _isLoading = false;
                    });
                    Navigator.pop(context);
                    showSnackbar(context, Colors.green, "Group Created Successfully!");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constants().primaryColor,
                ),
                child: const Text(
                  "Create",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          );
        },
      );
    });
  }

  groupList() {
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        if(snapshot.hasData) {
          if(snapshot.data['groups'] != null) {
            if(snapshot.data['groups'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['groups'].length,
                itemBuilder: (context, index) {
                  int reverseIndex = snapshot.data['groups'].length - index - 1;
                  return GroupTile(
                    userName: userName,
                    groupId: getId(snapshot.data['groups'][reverseIndex]),
                    groupName: getName(snapshot.data['groups'][reverseIndex]),
                  );
                },
              );
            }
            else {
              return noGroupWidget();
            }
          }
          else {
            return noGroupWidget();
          }
        }
        else {
          return Center(
            child: CircularProgressIndicator(
              color: Constants().primaryColor,
            ),
          );
        }
      },
    );
  }

  noGroupWidget() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              popUpDialog(context);
            },
            child: Icon(
              Icons.add_circle,
              color: Colors.grey[700],
              size: 75,
            ),
          ),
          const SizedBox(height: 20,),
          const Text(
            "You have not joined any groups, tap on the + icon to create a group or also search from top search button.",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
