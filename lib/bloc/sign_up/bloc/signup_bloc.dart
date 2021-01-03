import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tinder/repositories/user_repositories.dart';
import 'package:tinder/ui/validators.dart';
import 'package:rxdart/rxdart.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc(this._userRepository) : super(SignUpState.empty());

  UserRepository _userRepository;

  @override
  Stream<Transition<SignUpEvent, SignUpState>> transformEvents(
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
  Stream<SignUpState> mapEventToState(
    SignUpEvent event,
  ) async* {
    if (event is EmailChanged) {
      //ketika email berubah
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      //ketika password berubah
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is SignUpWithCredentialsPressed) {
      //ketika event signup kredensial
      yield* _mapSignUpWithCredentialsPressedToState(
          email: event.email, password: event.password);
    }
  }


   Stream<SignUpState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<SignUpState> _mapPasswordChangedToState(String password) async* {
    yield state.update(isPasswordValid: Validators.isValidPassword(password));
  }

  Stream<SignUpState> _mapSignUpWithCredentialsPressedToState({
    String email,
    String password,
  }) async* {
    yield SignUpState.loading();

    try {
      await _userRepository.signUpWithEmail(email, password);

      yield SignUpState.success();
    } catch (_) {
      SignUpState.failure();
    }
  }

}

