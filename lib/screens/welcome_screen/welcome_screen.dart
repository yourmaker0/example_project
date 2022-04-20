import 'package:example_project/generated/l10n.dart';
import 'package:example_project/screens/log_in_screen/log_in_screen.dart';
import 'package:example_project/screens/sign_up_screen/sign_up_screen.dart';
import 'package:example_project/styles/text_styles.dart';
import 'package:example_project/widgets/main_button/main_button.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 20, right: 16, left: 16),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  S.of(context).welcomeToExampleApplication,
                  style: ProjectTextStyles.ui_16Medium,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            MainButton(
              title: S.of(context).createAccount,
              onTap: () => navigateToSignUp(context),
            ),
            const SizedBox(height: 20),
            MainButton(
              title: S.of(context).logIn,
              onTap: () => navigateToLoginScreen(context),
            )
          ],
        ),
      ),
    );
  }

  void navigateToSignUp(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignUpScreen(),
      ),
    );
  }

  void navigateToLoginScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LogInScreen(),
      ),
    );
  }
}
