import 'package:flutter/material.dart';
import 'package:tinder/ui/utilities.dart';

class Message extends StatefulWidget {

final String userId;
Message({ this.userId });

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorRed,
        body: Center(
          child: Text('Message Menu'),
        ));
  }
}