import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tinder/bloc/search/bloc/search_bloc.dart';
import 'package:tinder/model/user.dart';
import 'package:tinder/repositories/search_repositories.dart';
import 'package:tinder/ui/utilities.dart';

class Search extends StatefulWidget {
  final String userId;
  Search({this.userId});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  final SearchRepository _searchRepository = SearchRepository();
  SearchBloc _searchBloc;
  User _user, _currentUser;
  int difference;

  getDifference(GeoPoint userLocation) async {
    Position position = await Geolocator.getCurrentPosition();

    double location = Geolocator.distanceBetween(userLocation.latitude,
        userLocation.longitude, position.latitude, position.longitude);

    difference = location.toInt();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorRed,
        body: Center(
          child: Text('Search Menu'),
        ));
  }
}
