part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoadingLoginState extends LoginState {}

class ErrorLoginState extends BaseBlocError implements LoginState {
  ErrorLoginState(Object e, StackTrace stackTrace) : super(e, stackTrace);
}

class AuthorizedState extends LoginState {}

class UnauthorizedState extends LoginState {}
