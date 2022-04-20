import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:example_project/core/error_handler/error_handler.dart';
import 'package:example_project/data/network/models/request/paggination.dart';
import 'package:example_project/data/network/models/response/dto_characters_response.dart';
import 'package:example_project/data/repositories/global_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

part 'characters_event.dart';

part 'characters_state.dart';

class CharactersBloc extends Bloc<CharactersEvent, CharactersState> {
  final GlobalRepository _repository;
  late final Pagination _pagination;

  CharactersBloc(this._repository) : super(LoadingCharactersState()) {
    on<InitialCharactersEvent>(_onInitialCharactersEvent);
    on<LoadNextPageCharactersEvent>(_onLoadNextPageCharactersEvent);
  }

  Future<FutureOr<void>> _onInitialCharactersEvent(
      InitialCharactersEvent event, Emitter<CharactersState> emit) async {
    try {
      emit(LoadingCharactersState());
      final response = await _repository.getAllCharacters(Pagination(page: 1));
      _pagination = Pagination(allCount: response.info.pages, page: 1);
      emit(DataCharactersState(characters: response.results));
    } catch (e, stackTrace) {
      emit(ErrorCharactersState(e, stackTrace));
      if (kDebugMode) rethrow;
    }
  }

  FutureOr<void> _onLoadNextPageCharactersEvent(
      LoadNextPageCharactersEvent event, Emitter<CharactersState> emit) async {
    try {
      final currentState = state;
      if (_pagination.incrementPage() && currentState is DataCharactersState) {
        emit(LoadingNextPageCharactersState());
        final response = await _repository.getAllCharacters(_pagination);
        emit(currentState.copyWith(
            characters: [...currentState.characters, ...response.results]));
      }
    } catch (e, stackTrace) {
      _pagination.decrementPage();
      emit(ErrorCharactersState(e, stackTrace));
      if (kDebugMode) rethrow;
    }
  }
}
