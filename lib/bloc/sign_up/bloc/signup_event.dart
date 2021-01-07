part of 'signup_bloc.dart';

//immutable = all fields should be final
@immutable
abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

//ketika email berubah
class EmailChanged extends SignUpEvent {
  final String email;

  EmailChanged({@required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'EmailChanged {email: $email}';
}

//ketika password berubah
class PasswordChanged extends SignUpEvent {
  final String password;

  PasswordChanged({@required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'PasswordChanged {password: $password}';
}

//ketika di submit
class Submitted extends SignUpEvent {
  final String email, password;

  Submitted({this.email, this.password});

  @override
  List<Object> get props => [email, password];
}

//signup dengan credential
class SignUpWithCredentialsPressed extends SignUpEvent {
  final String email, password;

  SignUpWithCredentialsPressed({@required this.email, @required this.password});

  @override
  List<Object> get props => [email, password];
}
