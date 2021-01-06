import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinder/bloc/profile/bloc/profile_bloc.dart';
import 'package:tinder/repositories/user_repositories.dart';
import 'package:tinder/ui/widgets/profile_form.dart';

import '../utilities.dart';

class Profile extends StatelessWidget {
  final _userRepository;
  final userId;

  Profile({@required UserRepository userRepository, String userId})
      : assert(userRepository != null && userId != null),
        _userRepository = userRepository,
        userId = userId;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(right: size.width * 0.03),
              child: Text(
                "Profile",
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
        backgroundColor: colorRed,
        elevation: 0,
      ),
      body: BlocProvider<ProfileBloc>(
        create: (context) => ProfileBloc(_userRepository),
        child: ProfileForm(
          userRepository: _userRepository,
        ),
      ),
    );
  }
}