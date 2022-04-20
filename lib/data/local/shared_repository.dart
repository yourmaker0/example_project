import 'package:shared_preferences/shared_preferences.dart';

import 'models/user_model.dart';

class LocalService {
  late final SharedPreferences _sharedPref;

  Future<void> init() async {
    _sharedPref = await SharedPreferences.getInstance();
  }

  Future<void> saveToken(String accessToken) async {
    await _sharedPref.setString(_SharedKeys.accessTokenKey, accessToken);
  }

  String getToken() {
    return _sharedPref.getString(_SharedKeys.accessTokenKey) ?? '';
  }

  Future<void> createUser(SharedUserModel user) {
    return _sharedPref.setString(user.hash, user.toJsonString());
  }

  Future<SharedUserModel> getCurrentUser(String userHash) async {
    final user = _sharedPref.getString(userHash) ?? '';
    return SharedUserModel.fromString(user);
  }

  Future<bool> isUserExist(String userHash) async {
    final fetchedUser = _sharedPref.getString(userHash);
    if (fetchedUser == null) return false;
    return true;
  }
}

class _SharedKeys {
  static const String accessTokenKey = 'access_token_key';
}
