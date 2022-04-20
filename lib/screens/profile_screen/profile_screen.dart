import 'package:example_project/core/error_handler/error_handler.dart';
import 'package:example_project/core/login_bloc/login_bloc.dart';
import 'package:example_project/data/repositories/global_repository.dart';
import 'package:example_project/data/repositories/tokens_repository.dart';
import 'package:example_project/generated/l10n.dart';
import 'package:example_project/screens/profile_screen/bloc/profile_bloc.dart';
import 'package:example_project/styles/text_styles.dart';
import 'package:example_project/widgets/loading_indicator/loading_indicator.dart';
import 'package:example_project/widgets/main_button/main_button.dart';
import 'package:example_project/widgets/snackbar/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(
          context.read<GlobalRepository>(), context.read<TokensRepository>())
        ..add(InitialProfileEvent()),
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ErrorProfileState) {
            showCustomSnackbar(
                context, context.read<ErrorHandler>().handleError(state));
          }
        },
        buildWhen: (p, c) => c is DataProfileState || c is LoadingProfileState,
        builder: (context, state) {
          if (state is LoadingProfileState) {
            return const LoadingIndicator();
          }
          if (state is DataProfileState) {
            return Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.person,
                        size: 60,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '${S.of(context).login}: ${state.user.login}',
                        style: ProjectTextStyles.ui_16Medium,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${S.of(context).name}: ${state.user.name}',
                        style: ProjectTextStyles.ui_16Regular,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${S.of(context).signUpTime}: ${state.user.signUpTime}',
                        style: ProjectTextStyles.ui_16Regular,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 20),
                      MainButton(
                          title: S.of(context).logOut,
                          onTap: () {
                            context.read<LoginBloc>().add(LogOutEvent());
                          })
                    ],
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
