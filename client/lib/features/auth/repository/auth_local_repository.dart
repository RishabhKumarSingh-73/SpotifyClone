import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_local_repository.g.dart';

@riverpod
// ignore: deprecated_member_use_from_same_package
AuthLocalRepository authLocalRepository(AuthLocalRepositoryRef ref) {
  return AuthLocalRepository();
}

class AuthLocalRepository {
  late SharedPreferences _sharedPreferences;

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<void> setToken(String? token) async {
    if (token != null) {
      _sharedPreferences.setString("x-auth-token", token);
    }
  }

  Future<void> unsetToken() async {
    _sharedPreferences.remove("x-auth-token");
  }

  String? getToken() {
    print(_sharedPreferences.getString("x-auth-token"));
    return _sharedPreferences.getString("x-auth-token");
  }
}
