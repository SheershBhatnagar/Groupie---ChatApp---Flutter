
import 'package:flutter/material.dart';

import 'package:groupie/shared/constants.dart';
import 'package:groupie/widgets/widgets.dart';

import '../pages/chat_page.dart';

class GroupTile extends StatelessWidget {

  final String userName;
  final String groupId;
  final String groupName;

  const GroupTile({
    super.key,
    required this.userName,
    required this.groupId,
    required this.groupName,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        nextScreen(context, ChatPage(
          groupId: groupId,
          groupName: groupName,
          userName: userName,
        ));
      },
      leading: CircleAvatar(
        backgroundColor: Constants().primaryColor,
        child: Text(
          groupName.substring(0, 1).toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(groupName,),
      subtitle: Text(
        "Join the conversation as $userName",
        style: const TextStyle(
          color: Colors.grey,
        ),
      ),
    );
  }
}
