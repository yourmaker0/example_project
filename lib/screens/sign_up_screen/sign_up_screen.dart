import 'package:example_project/core/error_handler/error_handler.dart';
import 'package:example_project/core/login_bloc/login_bloc.dart';
import 'package:example_project/data/repositories/global_repository.dart';
import 'package:example_project/generated/l10n.dart';
import 'package:example_project/screens/sign_up_screen/bloc/sign_up_bloc.dart';
import 'package:example_project/styles/formatters.dart';
import 'package:example_project/widgets/loading_layer/loading_layer.dart';
import 'package:example_project/widgets/main_button/main_button.dart';
import 'package:example_project/widgets/main_text_field/main_text_field.dart';
import 'package:example_project/widgets/snackbar/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return LoadingLayerProvider(
      child: BlocProvider(
        create: (context) => SignUpBloc(context.read<GlobalRepository>()),
        child: BlocConsumer<SignUpBloc, SignUpState>(
          listener: (context, state) {
            if (state is SuccessSignUpState) {
              context.read<LoginBloc>().add(LogInEvent(state.token));
            }
            if (state is ErrorSignUpState) {
              showCustomSnackbar(
                  context, context.read<ErrorHandler>().handleError(state));
            }
            if (state is LoadingSignUpState) {
              LoadingLayer.showOrHide(context, isShow: state.isLoading);
            }
          },
          buildWhen: (p, c) => c is InitialSignUpState,
          builder: (context, state) {
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MainTextField(
                        controller: loginController,
                        hintText: S.of(context).login,
                        validate: (value) {
                          return validateEmpty(context, value) ??
                              validateNotContainSpaces(context, value);
                        },
                      ),
                      const SizedBox(height: 20),
                      MainTextField(
                        controller: passwordController,
                        hintText: S.of(context).password,
                        obscureText: true,
                        maxLines: 1,
                        validate: (value) {
                          return validateEmpty(context, value) ??
                              validateNotContainSpaces(context, value) ??
                              validatePasswordsMatch(context);
                        },
                      ),
                      const SizedBox(height: 20),
                      MainTextField(
                        controller: repeatPasswordController,
                        hintText: S.of(context).password,
                        obscureText: true,
                        maxLines: 1,
                        validate: (value) {
                          return validateEmpty(context, value) ??
                              validateNotContainSpaces(context, value) ??
                              validatePasswordsMatch(context);
                        },
                      ),
                      const SizedBox(height: 20),
                      MainTextField(
                        controller: nameController,
                        hintText: S.of(context).name,
                        validate: (value) {
                          return validateEmpty(context, value);
                        },
                      ),
                      const SizedBox(height: 40),
                      MainButton(
                          title: S.of(context).createAccount,
                          onTap: () {
                            onCreateAccountTap(context);
                          }),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String? validatePasswordsMatch(BuildContext context) {
    if (passwordController.text != repeatPasswordController.text) {
      return S.of(context).passwordsMustMatch;
    }
    return null;
  }

  String? validateNotContainSpaces(BuildContext context, String value) {
    if (value.contains(' ')) return S.of(context).fieldMustNotContainSpaces;
    return null;
  }

  String? validateEmpty(BuildContext context, String value) {
    if (value.isEmpty) return S.of(context).fieldShouldNotBeEmpty;
    return null;
  }

  void onCreateAccountTap(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<SignUpBloc>().add(
            SignUpSignUpEvent(
              passwordController.text,
              loginController.text,
              nameController.text,
              Formatters.mainTime(
                DateTime.now(),
              ),
            ),
          );
    }
  }
}
