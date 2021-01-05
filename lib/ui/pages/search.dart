import 'package:flutter/material.dart';
import 'package:tinder/ui/utilities.dart';

class Search extends StatefulWidget {
  final String userId;
  Search({this.userId});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorRed,
        body: Center(
          child: Text('Search Menu'),
        ));
  }
}
