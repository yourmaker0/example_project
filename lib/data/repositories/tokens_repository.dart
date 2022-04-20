import 'dart:developer';

import 'package:example_project/data/local/shared_repository.dart';

class TokensRepository {
  late final LocalService _localService;

  String _accessToken = '';

  String get accessToken => _accessToken;

  Future init(LocalService localService) async {
    _localService = localService;
    _accessToken = _localService.getToken();
  }

  bool hasToken() => accessToken.isNotEmpty;

  Future<void> save(String accessToken) async {
    _accessToken = accessToken;
    await _localService.saveToken(accessToken);
    _accessToken = accessToken;
  }

  Future<bool> delete() async {
    try {
      await _localService.saveToken('');
      _accessToken = '';
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
