import 'package:example_project/core/error_handler/exceptions/base_exception.dart';
import 'package:example_project/generated/l10n.dart';
import 'package:flutter/foundation.dart';

class ErrorHandler {
  late final S _lang;

  ErrorHandler();

  void initialize(
    S lang,
  ) {
    _lang = lang;
  }

  String handleError(
    BaseBlocError baseBlocError, {
    ErrorAction? action,
  }) {
    final ex = baseBlocError.e;
    if (ex is LocalizedException) return ex.toLocalizedMessage(_lang);
    return _lang.something_went_wrong;
  }

  void loggingError(BaseBlocError baseBlocError) {
    if (kDebugMode) throw baseBlocError.e;
    //todo send to crashlytics
  }
}

class BaseBlocError {
  final Object e;
  final StackTrace? stackTrace;

  BaseBlocError(this.e, this.stackTrace);
}

enum ErrorAction {
  verifyEmail,
}
