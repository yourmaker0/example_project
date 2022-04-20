part of 'characters_bloc.dart';

@immutable
abstract class CharactersEvent {}

class InitialCharactersEvent extends CharactersEvent {}

class LoadNextPageCharactersEvent extends CharactersEvent {}
