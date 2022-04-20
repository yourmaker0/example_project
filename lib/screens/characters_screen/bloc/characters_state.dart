part of 'characters_bloc.dart';

@immutable
abstract class CharactersState {}

class LoadingCharactersState extends CharactersState {}

class LoadingNextPageCharactersState extends CharactersState {}

class DataCharactersState extends CharactersState {
  final List<DTOCharacter> characters;

  DataCharactersState({required this.characters});

  DataCharactersState copyWith({
    List<DTOCharacter>? characters,
  }) {
    return DataCharactersState(
      characters: characters ?? this.characters,
    );
  }
}

class ErrorCharactersState extends BaseBlocError implements CharactersState {
  ErrorCharactersState(Object e, StackTrace? stackTrace) : super(e, stackTrace);
}
