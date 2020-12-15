import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tinder/repositories/user_repositories.dart';
import 'package:tinder/ui/validators.dart';
import 'package:rxdart/rxdart.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._userRepository) : super(LoginState.empty());

  UserRepository _userRepository;

  @override
  Stream<Transition<LoginEvent, LoginState>> transformEvents(
      events, next) {
    final nonDebounceStream = events.where((event){
      return (event is! EmailChanged || event is! PasswordChanged);
    });

    final debounceStream = events.where((event) {
      return (event is EmailChanged || event is PasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));

    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), next);
  }

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is EmailChanged) {
      //ketika email berubah
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      //ketika password berubah
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is LoginWithCredentialsPressed) {
      //ketika event login kredensial
      yield* _mapLoginWithCredentialsPressedToState(
          email: event.email, password: event.password);
    }
  }


   Stream<LoginState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<LoginState> _mapPasswordChangedToState(String password) async* {
    yield state.update(isEmailValid: Validators.isValidPassword(password));
  }

  Stream<LoginState> _mapLoginWithCredentialsPressedToState({
    String email,
    String password,
  }) async* {
    yield LoginState.loading();

    try {
      await _userRepository.signInWithEmail(email, password);

      yield LoginState.success();
    } catch (_) {
      LoginState.failure();
    }
  }

}
