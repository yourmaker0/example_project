part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

class LoadingProfileState extends ProfileState {}

class DataProfileState extends ProfileState {
  final SharedUserModel user;

  DataProfileState(this.user);
}

class ErrorProfileState extends BaseBlocError implements ProfileState {
  ErrorProfileState(Object e, StackTrace? stackTrace) : super(e, stackTrace);
}
