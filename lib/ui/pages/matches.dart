import 'package:flutter/material.dart';

class Matches extends StatefulWidget {

final String userId;
Matches({ this.userId });

  @override
  _MatchesState createState() => _MatchesState();
}

class _MatchesState extends State<Matches> {
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Matches Menu'),
    );
  }
}