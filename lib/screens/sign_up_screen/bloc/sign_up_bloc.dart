import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:example_project/core/error_handler/error_handler.dart';
import 'package:example_project/data/repositories/global_repository.dart';
import 'package:meta/meta.dart';

part 'sign_up_event.dart';

part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final GlobalRepository _repository;

  SignUpBloc(this._repository) : super(InitialSignUpState()) {
    on<SignUpSignUpEvent>(_onSignUpSignUpEvent);
    on<SignInSignUpEvent>(_onSignInSignUpEvent);
  }

  FutureOr<void> _onSignUpSignUpEvent(
      SignUpSignUpEvent event, Emitter<SignUpState> emit) async {
    try {
      emit(LoadingSignUpState());
      final token = await _repository.signUp(
          event.login, event.password, event.name, event.time);
      await Future.delayed(const Duration(seconds: 1));
      emit(SuccessSignUpState(token));
    } catch (e, stackTrace) {
      ErrorSignUpState(e, stackTrace);
    } finally {
      emit(LoadingSignUpState(isLoading: false));
    }
  }

  FutureOr<void> _onSignInSignUpEvent(
      SignInSignUpEvent event, Emitter<SignUpState> emit) async {
    try {
      emit(LoadingSignUpState());
      final token = await _repository.signIn(event.login, event.password);
      await Future.delayed(const Duration(seconds: 1));
      emit(SuccessSignUpState(token));
    } catch (e, stackTrace) {
      emit(ErrorSignUpState(e, stackTrace));
    } finally {
      emit(LoadingSignUpState(isLoading: false));
    }
  }
}
