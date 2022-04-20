import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:example_project/core/error_handler/error_handler.dart';
import 'package:example_project/data/local/models/user_model.dart';
import 'package:example_project/data/repositories/global_repository.dart';
import 'package:example_project/data/repositories/tokens_repository.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GlobalRepository _repository;
  final TokensRepository _tokensRepository;

  ProfileBloc(this._repository, this._tokensRepository)
      : super(LoadingProfileState()) {
    on<InitialProfileEvent>(_onInitialProfileEvent);
  }

  Future<FutureOr<void>> _onInitialProfileEvent(
      InitialProfileEvent event, Emitter<ProfileState> emit) async {
    try {
      emit(LoadingProfileState());
      final user =
          await _repository.getCurrentUser(_tokensRepository.accessToken);
      await Future.delayed(const Duration(milliseconds: 500));
      emit(DataProfileState(user));
    } catch (e, stackTrace) {
      emit(ErrorProfileState(e, stackTrace));
    }
  }
}
