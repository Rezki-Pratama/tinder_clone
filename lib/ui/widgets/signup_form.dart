import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinder/bloc/authentication/bloc/authentication_bloc.dart';
import 'package:tinder/bloc/sign_up/bloc/signup_bloc.dart';
import 'package:tinder/repositories/user_repositories.dart';
import 'package:tinder/ui/utilities.dart';

class SignUpForm extends StatefulWidget {
  final UserRepository _userRepository;

  SignUpForm({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  SignUpBloc _signUpBloc;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isSignUpButtonEnabled(SignUpState state) {
    return isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    _signUpBloc = BlocProvider.of<SignUpBloc>(context);

    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);

    super.initState();
  }

  void _onFormSubmitted() {
    _signUpBloc.add(
      SignUpWithCredentialsPressed(
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

    return BlocConsumer<SignUpBloc, SignUpState>(
      listener: (BuildContext context, SignUpState state) {
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Sign Up Failed"),
                    Icon(Icons.error),
                  ],
                ),
              ),
            );
        }
        if (state.isSubmitting) {
          print("isSubmitting");
          Scaffold.of(context)
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Signing up..."),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          print("Success");
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            color: colorRed,
            width: size.width,
            height: size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(size.height * 0.02),
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
                          return state.isEmailValid ? "Invalid Email" : null;
                        },
                        style: TextStyle(color: colorRed),
                        decoration: InputDecoration(
                          hintText: "Email",
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: colorRed)),
                          focusedBorder:
                              UnderlineInputBorder(borderSide: BorderSide.none),
                          enabledBorder:
                              UnderlineInputBorder(borderSide: BorderSide.none),
                          errorStyle: TextStyle(color: colorRed),
                          hintStyle: TextStyle(
                              color: colorRed, fontSize: size.height * 0.02),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(size.height * 0.02),
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
                          hintText: "Password",
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: colorRed)),
                          focusedBorder:
                              UnderlineInputBorder(borderSide: BorderSide.none),
                          enabledBorder:
                              UnderlineInputBorder(borderSide: BorderSide.none),
                          errorStyle: TextStyle(color: colorRed),
                          hintStyle: TextStyle(
                              color: colorRed, fontSize: size.height * 0.02),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(size.height * 0.02),
                  child: GestureDetector(
                    onTap:
                        isSignUpButtonEnabled(state) ? _onFormSubmitted : null,
                    child: Material(
                      color: colorRed,
                      elevation: 20,
                      borderRadius: BorderRadius.circular(size.height * 0.03),
                      child: Container(
                        height: size.height * 0.09,
                        decoration: BoxDecoration(
                          color: isSignUpButtonEnabled(state)
                              ? Colors.white
                              : colorRed,
                          borderRadius:
                              BorderRadius.circular(size.height * 0.03),
                        ),
                        child: Center(
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                                fontSize: size.height * 0.040,
                                color: isSignUpButtonEnabled(state)
                                    ? colorRed
                                    : Colors.white,fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(size.height * 0.03),
                child: Text('Or' ,style: TextStyle(color: Colors.white, fontSize: size.height * 0.025))
                ),
                Padding(
                  padding: EdgeInsets.all(size.height * 0.02),
                child: Material(
                  color: Colors.white,
                      elevation: 20,
                      borderRadius: BorderRadius.circular(size.height * 0.03),
                      child: Container(
                        height: size.height * 0.09,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: size.width * 0.10,
                              child: Image.asset('assets/GoogleLogo.png')),
                            SizedBox(width: size.width * 0.03),
                            Text('Login with Google',style: TextStyle(color: colorRed, fontSize: size.height * 0.025,fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                )),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.height * 0.02),
                child: Material(
                  color: Colors.white,
                      elevation: 20,
                      borderRadius: BorderRadius.circular(size.height * 0.03),
                      child: Container(
                        height: size.height * 0.09,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: size.width * 0.10,
                              child: Image.asset('assets/FacebookLogo.png')),
                            SizedBox(width: size.width * 0.03),
                            Text('Login with Facebook',style: TextStyle(color: colorRed, fontSize: size.height * 0.025,fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                )),
                SizedBox(height: size.height * 0.10)
                

              ],
            ),
          ),
        );
      },
    );
  }

  void _onEmailChanged() {
    _signUpBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _signUpBloc.add(
      PasswordChanged(password: _passwordController.text),
    );
  }
}
