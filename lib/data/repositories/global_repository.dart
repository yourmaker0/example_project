import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:example_project/core/error_handler/exceptions/base_exception.dart';
import 'package:example_project/data/local/models/user_model.dart';
import 'package:example_project/data/local/shared_repository.dart';
import 'package:example_project/data/network/models/request/paggination.dart';
import 'package:example_project/data/network/models/response/dto_characters_response.dart';
import 'package:example_project/data/network/services/network_service.dart';

class GlobalRepository {
  late final LocalService _localService;
  late final NetworkService _networkService;

  void init(LocalService localService, NetworkService networkService) {
    _localService = localService;
    _networkService = networkService;
  }

  Future<String> signUp(
    String login,
    String password,
    String name,
    String signUpTime,
  ) async {
    String hash = _getHash(login, password);
    final userModel = SharedUserModel(
      login: login,
      pass: password,
      hash: hash.toString(),
      name: name,
      signUpTime: signUpTime,
    );
    final userExist = await _localService.isUserExist(hash);
    if (!userExist) await _localService.createUser(userModel);
    return hash;
  }

  String _getHash(String login, String password) {
    final bytes = utf8.encode(login + password);
    final hash = sha1.convert(bytes).toString();
    return hash;
  }

  Future<String> signIn(String login, String password) async {
    String hash = _getHash(login, password);
    final userExist = await _localService.isUserExist(hash);
    if (userExist) return hash;
    throw AuthException(AuthExceptionTypes.userDoesNotExist);
  }

  Future<SharedUserModel> getCurrentUser(String hash) =>
      _localService.getCurrentUser(hash);

  Future<DTOCharactersResponse> getAllCharacters(Pagination pagination) async =>
      _networkService.getAllCharacters(pagination.page);
}
