import 'package:flutter/material.dart';

class Search extends StatefulWidget {

final String userId;
Search({ this.userId });

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Search Menu'),
    );
  }
}