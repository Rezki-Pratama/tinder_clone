import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinder/bloc/authentication/bloc/authentication_bloc.dart';
import 'package:tinder/bloc/login/bloc/login_bloc.dart';
import 'package:tinder/repositories/user_repositories.dart';
import 'package:tinder/ui/pages/sign_up.dart';
import 'package:tinder/ui/utilities.dart';
import 'package:tinder/ui/widgets/custom_button.dart';

class LoginForm extends StatefulWidget {
  final UserRepository _userRepository;
  LoginForm({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  LoginBloc _loginBloc;

  UserRepository get _userRepository => widget._userRepository;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    _loginBloc = BlocProvider.of<LoginBloc>(context);

    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);

    super.initState();
  }

  void _onEmailChanged() {
    _loginBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _loginBloc.add(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
    _loginBloc.add(
      LoginWithCredentialsPressed(
          email: _emailController.text, password: _passwordController.text),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocListener<LoginBloc, LoginState>(listener: (context, state) {
      if (state.isFailure) {
        Scaffold.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Login Failed"),
                  Icon(Icons.error),
                ],
              ),
            ),
          );
      }

      if (state.isSubmitting) {
        print("isSubmitting");
        Scaffold.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(" Logging In..."),
                  CircularProgressIndicator(),
                ],
              ),
            ),
          );
      }

      if (state.isSuccess) {
        print("Success");
        BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
      }
    }, child: BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Container(
            color: colorRed,
            width: size.width,
            height: size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: size.width / 2,
                    child: Image.asset('assets/LinjanganLogo.png')),
                Text(
                  "Linjangan",
                  style: TextStyle(
                      fontSize: size.width * 0.1, color: Colors.white),
                ),
                Padding(
                  padding: EdgeInsets.all(size.height * 0.03),
                  child: Material(
                    color: Colors.white,
                    elevation: 20,
                    borderRadius: BorderRadius.circular(size.height * 0.03),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: size.height * 0.01,
                          horizontal: size.height * 0.02),
                      child: TextFormField(
                        controller: _emailController,
                        autovalidate: true,
                        validator: (_) {
                          return !state.isEmailValid ? "Invalid Email" : null;
                        },
                        style: TextStyle(color: colorRed),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: -10),
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: colorRed)),
                          focusedBorder:
                              UnderlineInputBorder(borderSide: BorderSide.none),
                          enabledBorder:
                              UnderlineInputBorder(borderSide: BorderSide.none),
                          hintText: "Email",
                          errorStyle: TextStyle(color: colorRed),
                          hintStyle: TextStyle(
                              color: colorRed, fontSize: size.height * 0.02),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(size.height * 0.03),
                  child: Material(
                    color: Colors.white,
                    elevation: 20,
                    borderRadius: BorderRadius.circular(size.height * 0.03),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: size.height * 0.01,
                          horizontal: size.height * 0.02),
                      child: TextFormField(
                        controller: _passwordController,
                        autocorrect: false,
                        obscureText: true,
                        autovalidate: true,
                        validator: (_) {
                          return !state.isPasswordValid
                              ? "Invalid Password"
                              : null;
                        },
                        style: TextStyle(color: colorRed),
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: colorRed)),
                          focusedBorder:
                              UnderlineInputBorder(borderSide: BorderSide.none),
                          enabledBorder:
                              UnderlineInputBorder(borderSide: BorderSide.none),
                          hintText: "Password",
                          errorStyle: TextStyle(color: colorRed),
                          hintStyle: TextStyle(
                              color: colorRed, fontSize: size.height * 0.02),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(size.height * 0.03),
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                          onTap: isLoginButtonEnabled(state)
                              ? _onFormSubmitted
                              : null,
                          child: CustomButton(
                            text: 'LOGIN',
                            color: colorRed,
                            boxDecorationColor: isLoginButtonEnabled(state)
                                ? Colors.white
                                : colorRed,
                            textColor: isLoginButtonEnabled(state)
                                ? colorRed
                                : Colors.white,
                          )),
                      SizedBox(
                        height: size.height * 0.04,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return SignUp(
                                  userRepository: _userRepository,
                                );
                              },
                            ),
                          );
                        },
                        child: Text(
                          "Are you new? Get an Account",
                          style: TextStyle(
                              fontSize: size.height * 0.025,
                              color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ));
  }
}
