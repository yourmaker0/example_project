import 'dart:async';

import 'package:example_project/core/dependency_initializer/dependency_initializer.dart';
import 'package:example_project/data/local/shared_repository.dart';
import 'package:example_project/data/network/services/network_service.dart';
import 'package:example_project/data/repositories/global_repository.dart';
import 'package:example_project/data/repositories/tokens_repository.dart';
import 'package:example_project/screens/bottom_nav_bar_screen/bottom_nav_bar_screen.dart';
import 'package:example_project/screens/welcome_screen/welcome_screen.dart';
import 'package:example_project/widgets/loading_indicator/loading_indicator.dart';
import 'package:example_project/widgets/snackbar/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/dependency_provider/dependency_provider.dart';
import 'core/error_handler/error_handler.dart';
import 'core/login_bloc/login_bloc.dart';
import 'core/top_level_blocs/top_level_blocs.dart';
import 'generated/l10n.dart';

///need to avoid double initialization after change list of dependencies,
///depend LoginBloc state.
final GlobalKey mainGlobalKey = GlobalKey(debugLabel: 'MainGlobalKey');

void main() {
  ///initialization dependencies
  Future<void> initialize(BuildContext context) async {
    try {
      context.read<ErrorHandler>().initialize(S.current);
      final localService = context.read<LocalService>();
      await localService.init();
      context.read<TokensRepository>().init(localService);
      final loginBloc = context.read<LoginBloc>();
      loginBloc.init(context.read<TokensRepository>());
      loginBloc.add(InitialLoginEvent());
      context.read<GlobalRepository>().init(
            localService,
            context.read<NetworkService>(),
          );
    } catch (e) {
      rethrow;
    }
  }

  ///initialization dependencies, which need only after login
  Future<void> afterLoginInitializer(BuildContext context) async {
    context.read<ErrorHandler>();
  }

  // runZonedGuarded(() async {
  runApp(
    MyApp(
      initializer: initialize,
      afterLoginInitializer: afterLoginInitializer,
    ),
  );
  // }, (e, stackTrace) {
  //   //todo logging or crashlytics
  // });
}

class MyApp extends StatelessWidget {
  const MyApp(
      {Key? key,
      required this.initializer,
      required this.afterLoginInitializer})
      : super(key: key);

  final Future<void> Function(BuildContext) initializer;
  final Future<void> Function(BuildContext) afterLoginInitializer;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return TopLevelBlocs(
      child: DependenciesProvider(
        child: MaterialApp(
          key: mainGlobalKey,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          title: 'Example Application',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: DependenciesInitializer(
            loadingIndicatorScreen: const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            initializer: initializer,
            child: MainAuthorization(
              afterLoginInitializer: afterLoginInitializer,
            ),
          ),
        ),
      ),
    );
  }
}

class MainAuthorization extends StatelessWidget {
  final Future<void> Function(BuildContext) afterLoginInitializer;

  const MainAuthorization({Key? key, required this.afterLoginInitializer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) async {
        if (state is AuthorizedState) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
        if (state is ErrorLoginState) {
          showCustomSnackbar(
              context, context.read<ErrorHandler>().handleError(state));
        }
      },
      buildWhen: (p, c) => (c is LoadingLoginState ||
          c is UnauthorizedState ||
          c is AuthorizedState),
      builder: (context, state) {
        if (state is LoadingLoginState) {
          return const Material(child: LoadingIndicator());
        }
        if (state is UnauthorizedState) {
          return const Application(
            false,
            key: ValueKey(0),
          );
        }
        if (state is AuthorizedState) {
          ///Initialize after login dependencies
          return DependenciesInitializer(
            key: const ValueKey(1),
            initializer: afterLoginInitializer,
            loadingIndicatorScreen: const Scaffold(
              body: LoadingIndicator(),
            ),
            child: const Application(
              true,
              key: ValueKey(1),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class Application extends StatelessWidget {
  final bool isAuthenticated;

  const Application(this.isAuthenticated, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isAuthenticated ? BottomNavBarScreen() : const WelcomeScreen();
  }
}
