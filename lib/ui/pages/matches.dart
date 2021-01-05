import 'package:flutter/material.dart';
import 'package:tinder/ui/utilities.dart';

class Matches extends StatefulWidget {
  final String userId;
  Matches({this.userId});

  @override
  _MatchesState createState() => _MatchesState();
}

class _MatchesState extends State<Matches> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorRed,
        body: Center(
          child: Text('Matches Menu'),
        ));
  }
}
