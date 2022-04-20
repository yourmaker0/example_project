part of 'sign_up_bloc.dart';

@immutable
abstract class SignUpState {}

class InitialSignUpState extends SignUpState {}

class ErrorSignUpState extends BaseBlocError implements SignUpState {
  ErrorSignUpState(Object e, StackTrace? stackTrace) : super(e, stackTrace);
}

class LoadingSignUpState extends SignUpState {
  final bool isLoading;

  LoadingSignUpState({this.isLoading = true});
}

class SuccessSignUpState extends SignUpState {
  final String token;

  SuccessSignUpState(this.token);
}
