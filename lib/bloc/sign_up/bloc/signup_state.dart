part of 'signup_bloc.dart';

//immutable = all fields should be final
@immutable
class SignUpState {
  final bool isEmailValid, isPasswordValid, isSubmitting, isSuccess, isFailure;

  //getter is form valid
  bool get isFormValid => isEmailValid && isPasswordValid;

  SignUpState(
      {@required this.isEmailValid,
      @required this.isPasswordValid,
      @required this.isSubmitting,
      @required this.isSuccess,
      @required this.isFailure});

  //initial state / empty
  factory SignUpState.empty() {
    return SignUpState(
        isEmailValid: true,
        isPasswordValid: true,
        isSubmitting: false,
        isFailure: false,
        isSuccess: false);
  }

  factory SignUpState.loading() {
    return SignUpState(
        isEmailValid: true,
        isPasswordValid: true,
        isSubmitting: true,
        isFailure: false,
        isSuccess: false);
  }

  factory SignUpState.failure() {
    return SignUpState(
        isEmailValid: true,
        isPasswordValid: true,
        isSubmitting: false,
        isFailure: true,
        isSuccess: false);
  }

  factory SignUpState.success() {
    return SignUpState(
        isEmailValid: true,
        isPasswordValid: true,
        isSubmitting: false,
        isFailure: false,
        isSuccess: true);
  }

  SignUpState update({final bool isEmailValid, final bool isPasswordValid}) {
    return copyWith(
        isEmailValid: isEmailValid,
        isPasswordValid: isPasswordValid,
        isSubmitting: false,
        isFailure: false,
        isSuccess: true);
  }

  SignUpState copyWith(
      {bool isEmailValid,
      bool isPasswordValid,
      bool isSubmitting,
      bool isFailure,
      bool isSuccess}) {
    return SignUpState(
        //null coalescing operator  ex: 'abc' ?? ''
        isEmailValid: isEmailValid ?? this.isEmailValid,
        isPasswordValid: isPasswordValid ?? this.isPasswordValid,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        isSuccess: isSuccess ?? this.isSuccess,
        isFailure: isFailure ?? this.isFailure);
  }
}
