import 'package:bloc/bloc.dart';
import 'package:example_project/core/error_handler/error_handler.dart';
import 'package:example_project/data/repositories/tokens_repository.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  late final TokensRepository _tokensRepository;

  LoginBloc() : super(LoadingLoginState()) {
    on<InitialLoginEvent>((event, emit) => _onInitialLoginEvent(event, emit));
    on<LogInEvent>((event, emit) => _onLogInEvent(event, emit));
    on<LogOutEvent>((event, emit) => _onLogOutEvent(event, emit));
  }

  void init(TokensRepository tokensRepository) {
    _tokensRepository = tokensRepository;
  }

  _onInitialLoginEvent(InitialLoginEvent event, Emitter<LoginState> emit) {
    if (_tokensRepository.hasToken()) {
      emit(AuthorizedState());
    } else {
      emit(UnauthorizedState());
    }
  }

  _onLogInEvent(LogInEvent event, Emitter<LoginState> emit) async {
    try {
      await _tokensRepository.save(event.accessToken);
      emit(AuthorizedState());
    } catch (e, stackTrace) {
      emit(ErrorLoginState(e, stackTrace));
      emit(UnauthorizedState());
      rethrow;
    }
  }

  _onLogOutEvent(LogOutEvent event, Emitter<LoginState> emit) {
    try {
      _tokensRepository.delete();
      emit(UnauthorizedState());
    } catch (e, stackTrace) {
      emit(ErrorLoginState(e, stackTrace));
      rethrow;
    }
  }
}
