import 'dart:convert';

import 'package:equatable/equatable.dart';

class SharedUserModel extends Equatable {
  final String login;
  final String pass;
  final String hash;
  final String name;
  final String signUpTime;

  const SharedUserModel({
    required this.login,
    required this.pass,
    required this.hash,
    required this.name,
    required this.signUpTime,
  });

  String toJsonString() {
    return jsonEncode({
      'login': login,
      'hash': hash,
      'name': name,
      'sign_up_time': signUpTime,
    });
  }

  factory SharedUserModel.fromString(String jsonString) {
    final map = jsonDecode(jsonString);
    return SharedUserModel(
      login: map['login'] as String,
      pass: '',
      hash: map['hash'] as String,
      name: map['name'] as String,
      signUpTime: map['sign_up_time'] as String,
    );
  }

  @override
  List<Object?> get props => [login, pass];
}
