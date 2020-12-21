import 'package:flutter/material.dart';

class Message extends StatefulWidget {

final String userId;
Message({ this.userId });

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Message Menu'),
    );
  }
}