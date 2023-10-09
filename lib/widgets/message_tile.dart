
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';

import 'package:groupie/shared/constants.dart';

class MessageTile extends StatefulWidget {

  final String message;
  final String sender;
  final bool sentByMe;

  const MessageTile({
    super.key,
    required this.message,
    required this.sender,
    required this.sentByMe,
  });

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 5,
        left: widget.sentByMe ? MediaQuery.of(context).size.width - 300 : 10,
        right: widget.sentByMe ? 10 : MediaQuery.of(context).size.width - 300,
        bottom: 5,
      ),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: widget.sentByMe ? Constants().primaryColor : Constants().receiveMessageColor,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomLeft: widget.sentByMe ? const Radius.circular(20) : const Radius.circular(0),
          bottomRight: widget.sentByMe ? const Radius.circular(0) : const Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.sender,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 5,),
          Text(
            widget.message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          )
        ],
      ),
    );
  }
}
