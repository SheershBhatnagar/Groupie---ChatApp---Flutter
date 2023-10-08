
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:groupie/services/database_service.dart';

import '../shared/constants.dart';

class GroupInfo extends StatefulWidget {

  final String groupId;
  final String groupName;
  final String adminName;

  const GroupInfo({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.adminName,
  });

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {

  Stream? members;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getMember();
  }

  getMember() async {
    DatabaseService(uid: firebaseAuth.currentUser!.uid).getGroupMembers(widget.groupId).then((value) {
      setState(() {
        members = value;
      });
    });
  }

  String getName(String res) {
    return res.substring(res.indexOf("_")+1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Group Info",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Constants().primaryColor,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          IconButton(
            onPressed: () {

            },
            icon: const Icon(Icons.exit_to_app_rounded),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Constants().primaryColor.withOpacity(0.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Constants().primaryColor,
                    child: Text(
                      widget.groupName.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Group: ${widget.groupName}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 5,),
                      Text(
                        "Admin: ${getName(widget.adminName)}",
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            memberList(),
          ],
        ),
      ),
    );
  }

  memberList() {
    return StreamBuilder(
      stream: members,
      builder: (context, AsyncSnapshot snapshot) {
        if(snapshot.hasData) {
          if(snapshot.data['members'] != null || snapshot.data['members'].length != 0) {
            return Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 20,
                ),
                child: ListView.builder(
                  itemCount: snapshot.data['members'].length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Constants().primaryColor,
                        child: Text(
                          getName(snapshot.data['members'][index].toString()).substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      title: Text(getName(snapshot.data['members'][index].toString()),),
                    );
                  },
                ),
              ),
            );
          }
          else {
            return const Center(
              child: Text("No Members"),
            );
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
}
