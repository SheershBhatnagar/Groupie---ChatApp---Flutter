
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:groupie/helper/helper_function.dart';
import 'package:groupie/pages/chat_page.dart';
import 'package:groupie/services/database_service.dart';
import 'package:groupie/shared/constants.dart';
import 'package:groupie/widgets/widgets.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  TextEditingController searchController = TextEditingController();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  bool _isLoading = false;
  bool _hasUserSearched = false;
  bool _isJoined = false;

  QuerySnapshot? searchSnapshot;

  String userName = "";

  User? user;

  @override
  void initState() {
    super.initState();
    getCurrentUserIdAndName();
  }

  String getName(String res) {
    return res.substring(res.indexOf("_")+1);
  }

  getCurrentUserIdAndName() async {
    await HelperFunctions.getUserNameSF().then((value) {
      setState(() {
        userName = value!;
      });
    });

    user = firebaseAuth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Constants().primaryColor,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          "Search",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            color: Constants().primaryColor,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    keyboardType: TextInputType.text,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: "Search groups",
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      border: InputBorder.none,
                    ),
                    cursorColor: Colors.white,
                  ),
                ),
                InkWell(
                  onTap: () {
                    initiateSearch();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(
                      Icons.search_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _isLoading ? Center(
            child: CircularProgressIndicator(
              color: Constants().primaryColor,
            ),
          ) : groupList(),
        ],
      ),
    );
  }

  initiateSearch() async {

    if(searchController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      await DatabaseService().searchByName(searchController.text).then((snapshot) {
        setState(() {
          searchSnapshot = snapshot;
          _isLoading = false;
          _hasUserSearched = true;
        });
      });
    }
  }

  groupList() {
    return _hasUserSearched ? Expanded(
      child: ListView.builder(
        itemCount: searchSnapshot!.docs.length,
        itemBuilder: (context, index) {
          return groupTile(
            userName,
            searchSnapshot!.docs[index]['groupId'],
            searchSnapshot!.docs[index]['groupName'],
            searchSnapshot!.docs[index]['admin'],
          );
        },
      ),
    ) : Container();
  }

  joinedOrNot(String userName, String groupId, String groupName, String admin) async {
    await DatabaseService(uid: user!.uid).isUserJoined(groupName, groupId, userName).then((value) {
      setState(() {
        _isJoined = value;
      });
    });
  }

  Widget groupTile(String userName, String groupId, String groupName, String admin) {

    joinedOrNot(userName, groupId, groupName, admin);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      leading: CircleAvatar(
        backgroundColor: Constants().primaryColor,
        child: Text(
          groupName.substring(0, 1).toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      title: Text(groupName),
      subtitle: Text(
        "Admin: ${getName(admin)}",
        style: const TextStyle(
          color: Colors.grey,
        ),
      ),
      trailing: ElevatedButton(
        onPressed: () async {
          await DatabaseService(uid: user!.uid).toggleGroupJoin(groupId, userName, groupName);

          if(_isJoined) {
            setState(() {
              _isJoined = !_isJoined;
            });
            showSnackbar(context, Colors.green, "Welcome to the $groupName");
            
            Future.delayed(const Duration(seconds: 2), () {
              nextScreen(context, ChatPage(groupId: groupId, groupName: groupName, userName: userName));
            });
          }
          else {
            setState(() {
              _isJoined = !_isJoined;
            });
            showSnackbar(context, Colors.red, "Say bye to $groupName");
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _isJoined ? Constants().primaryColor.withOpacity(0.5) : Constants().primaryColor,
          elevation: 0,
        ),
        child: Text(
          _isJoined ? "Joined" : "Join",
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
