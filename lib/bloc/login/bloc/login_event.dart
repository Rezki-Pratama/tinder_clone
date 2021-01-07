part of 'login_bloc.dart';

//immutable = all fields should be final
@immutable
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

//ketika email berubah
class EmailChanged extends LoginEvent {
  final String email;

  EmailChanged({@required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'EmailChanged {email: $email}';
}

//ketika password berubah
class PasswordChanged extends LoginEvent {
  final String password;

  PasswordChanged({@required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'PasswordChanged {password: $password}';
}

//ketika di submit
class Submitted extends LoginEvent {
  final String email, password;

  Submitted({this.email, this.password});

  @override
  List<Object> get props => [email, password];
}

//login dengan credential
class LoginWithCredentialsPressed extends LoginEvent {
  final String email, password;

  LoginWithCredentialsPressed({@required this.email, @required this.password});

  @override
  List<Object> get props => [email, password];
}
