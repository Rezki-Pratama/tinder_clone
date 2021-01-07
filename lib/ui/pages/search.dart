import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tinder/bloc/search/bloc/search_bloc.dart';
import 'package:tinder/model/user.dart';
import 'package:tinder/repositories/search_repositories.dart';
import 'package:tinder/ui/utilities.dart';
import 'package:tinder/ui/widgets/card_user.dart';

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
  void initState() {
    _searchBloc = SearchBloc(_searchRepository);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: colorRed,
      body: BlocBuilder<SearchBloc, SearchState>(
        cubit: _searchBloc,
        builder: (context, state) {
          if (state is InitialSearchState) {
            _searchBloc.add(
              LoadUserEvent(userId: widget.userId),
            );
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.blueGrey),
              ),
            );
          }
          if (state is LoadingState) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            );
          }
          if (state is LoadUserState) {
            _user = state.user;
            _currentUser = state.currentUser;
            if (_user.location == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: size.width / 2,
                      child: Image.asset('assets/NoOne.png')),
                      SizedBox(height: size.width * 0.03),
                    Text(
                      "No One Here",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              );
            } else
              getDifference(_user.location);
            return CardSearch(
              photo: _user.photo,
              size: size,
              name: _user.name,
              gender: _user.gender,
              age: (DateTime.now().year - _user.age.toDate().year).toString(),
              location: difference != null
                  ? (difference / 1000).floor().toString() + "km away"
                  : "away",
              onSelect: () {
                _searchBloc.add(
                  SelectUserEvent(
                      name: _currentUser.name,
                      photoUrl: _currentUser.photo,
                      currentUserId: widget.userId,
                      selectedUserId: _user.uid),
                );
              },
              onClose: () {
                _searchBloc.add(SkipUserEvent(widget.userId, _user.uid));
              },
            );
          } else
            return Container();
        },
      ),
    );
  }
}
