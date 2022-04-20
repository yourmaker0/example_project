part of 'sign_up_bloc.dart';

@immutable
abstract class SignUpEvent {}

class SignUpSignUpEvent extends SignUpEvent {
  final String password;
  final String login;
  final String name;
  final String time;

  SignUpSignUpEvent(this.password, this.login, this.name, this.time);
}

class SignInSignUpEvent extends SignUpEvent {
  final String login;
  final String password;

  SignInSignUpEvent(this.login, this.password);
}
