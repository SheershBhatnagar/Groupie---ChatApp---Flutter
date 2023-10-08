
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:groupie/pages/group_info.dart';
import 'package:groupie/services/database_service.dart';
import 'package:groupie/shared/constants.dart';
import 'package:groupie/widgets/widgets.dart';

class ChatPage extends StatefulWidget {

  final String groupId;
  final String groupName;
  final String userName;

  const ChatPage({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.userName,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  Stream<QuerySnapshot>? chats;

  String admin = "";

  @override
  void initState() {
    super.initState();
    getChatAndAdmin();
  }

  getChatAndAdmin() {
    DatabaseService().getChats(widget.groupId).then((val) {
      setState(() {
        chats = val;
      });
    });

    DatabaseService().getGroupAdmin(widget.groupId).then((value) {
      setState(() {
        admin = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          widget.groupName,
          style: const TextStyle(
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
              nextScreen(context, GroupInfo(
                groupName: widget.groupName,
                groupId: widget.groupId,
                adminName: admin,
              ));
            },
            icon: const Icon(Icons.info_outline_rounded),
          ),
        ],
      ),
      body: Center(
        child: Text(
          widget.groupName,
        ),
      ),
    );
  }
}
