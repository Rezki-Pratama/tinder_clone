import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinder/bloc/sign_up/bloc/signup_bloc.dart';
import 'package:tinder/repositories/user_repositories.dart';
import 'package:tinder/ui/utilities.dart';
import 'package:tinder/ui/widgets/signup_form.dart';

class SignUp extends StatelessWidget {
  final UserRepository _userRepository;

  SignUp({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sign Up",
          style: TextStyle(fontSize: 30.0),
        ),
        centerTitle: true,
        backgroundColor: colorRed,
        elevation: 0,
      ),
      body: BlocProvider<SignUpBloc>(
        create: (context) => SignUpBloc(
          _userRepository
        ),
        child: SignUpForm(
          userRepository: _userRepository,
        ),
      ),
    );
  }
}