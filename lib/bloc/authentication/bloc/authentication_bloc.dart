import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tinder/repositories/user_repositories.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository, super(Uninitialised());

  final UserRepository _userRepository;

  //yield is used to add a single instance to the stream and yield* adds a (potential) stream of instances to the stream.

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapStartedToState() async* {
    try {
      final isSignedIn = await _userRepository.isSignedIn();
      //check jika login
      if (isSignedIn) {
        final uid = await _userRepository.getUser();
        final isFirstTime = await _userRepository.isFirstTime(uid);
        print('auth is exists :'+ isFirstTime.toString());
        //check jika bukan pertama kali login
        if (!isFirstTime) {
          yield AuthenticatedButNotSet(uid);
        } else {
          yield Authenticated(uid);
        }
      } else {
        yield UnAuthenticated();
      }
    } catch (_) {
      yield UnAuthenticated();
    }
  }

   Stream<AuthenticationState> _mapLoggedInToState() async* {
    final isFirstTime =
        await _userRepository.isFirstTime(await _userRepository.getUser());
        print('cek awal'+ isFirstTime.toString());
    if (!isFirstTime) {
      yield AuthenticatedButNotSet(await _userRepository.getUser());
    } else {
      yield Authenticated(await _userRepository.getUser());
    }
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield UnAuthenticated();
    _userRepository.signOut();
  }
}
