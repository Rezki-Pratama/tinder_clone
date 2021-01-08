part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class Uninitialised extends AuthenticationState {}

//state userId
class Authenticated extends AuthenticationState {
  final String userId;

  Authenticated(this.userId);

  //compare with equatable
  @override
  List<Object> get props => [userId];

  //bloc delegate
  @override
  String toString() => " Authenticated {userId} ";
}

class AuthenticatedButNotSet extends AuthenticationState {
  final String userId;

  AuthenticatedButNotSet(this.userId);

  //compare with equatable
  @override
  List<Object> get props => [userId];
}

class UnAuthenticated extends AuthenticationState {}
