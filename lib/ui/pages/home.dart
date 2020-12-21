import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinder/bloc/authentication/bloc/authentication_bloc.dart';
import 'package:tinder/repositories/user_repositories.dart';
import 'package:tinder/ui/pages/spash.dart';
import 'package:tinder/ui/widgets/tabs.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final UserRepository _userRepository = UserRepository();
  AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    
    _authenticationBloc = AuthenticationBloc(_userRepository);

    _authenticationBloc.add(AppStarted());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _authenticationBloc,
          child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: BlocBuilder(
            cubit: _authenticationBloc,
            builder: (context, state) {
              if(state is Uninitialised) {
                return Splash();
              } else {
                return Tabs();
              }
            },
          ),
        ),
      ),
    );
  }
}