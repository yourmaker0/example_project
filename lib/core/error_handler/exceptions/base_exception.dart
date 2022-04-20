import 'package:example_project/generated/l10n.dart';

abstract class LocalizedException implements Exception {
  String toLocalizedMessage(S lang);
}

class AuthException implements LocalizedException {
  final String? message;
  final AuthExceptionTypes type;

  AuthException(this.type, {this.message});

  @override
  String toLocalizedMessage(S locale) {
    return message ?? type.toLocalizedMessage(locale);
  }
}

enum AuthExceptionTypes { userDoesNotExist }

extension ToString on AuthExceptionTypes {
  toLocalizedMessage(S lang) {
    switch (this) {
      case AuthExceptionTypes.userDoesNotExist:
        return lang.userDoesntExitsPleaseSignUp;
    }
  }
}
