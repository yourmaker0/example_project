import 'package:example_project/core/error_handler/error_handler.dart';
import 'package:example_project/data/repositories/global_repository.dart';
import 'package:example_project/data/local/shared_repository.dart';
import 'package:example_project/data/network/services/network_service.dart';
import 'package:example_project/data/repositories/tokens_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../login_bloc/login_bloc.dart';

///Providers for global managers
class DependenciesProvider extends StatelessWidget {
  final Widget child;

  const DependenciesProvider({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return MultiProvider(
          providers: [
            RepositoryProvider(
              create: (_) => TokensRepository(),
            ),
            RepositoryProvider(
              create: (_) => NetworkService(),
            ),
            RepositoryProvider(
              create: (_) => GlobalRepository(),
            ),
            RepositoryProvider(
              create: (_) => LocalService(),
            ),
            RepositoryProvider(
              create: (_) => ErrorHandler(),
            ),

            ///after login dependencies
            if (state is AuthorizedState) ...[

            ],
          ],
          builder: (context, child) {
            return child!;
          },
          child: child,
        );
      },
    );
  }
}
