import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lsb_translator/config/user/user_config.dart';
import 'package:lsb_translator/domain/entities/user.dart';
import 'package:lsb_translator/mappers/user_mapper.dart';
import 'package:lsb_translator/shared/data/api_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  bool isAuth = false;
  User? user;

  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.url,
    ),
  );

  UserConfiguration userConfiguration;

  UserProvider({required this.userConfiguration}) {
    user = null;
  }

  void _saveCredentials(String? e, String? p) {
    userConfiguration
      ..email = e
      ..password = p
      ..haveCredentialsSaved = e != null && p != null
      ..save();
  }

  Future<bool> loginBiometrics() async {
    bool res = await userConfiguration.loginBiometric();
    if (res) {
      isAuth =
          await login(userConfiguration.email!, userConfiguration.password!);
    } else {
      reset();
    }

    notifyListeners();
    return isAuth;
  }

  Future<bool> login(String email, String password) async {
    isAuth = true;

    try {
      final response = await dio
          .post('/auth/login', data: {'email': email, 'password': password});

      user = UserMapper.userJsonToEntity(response.data['user']);
      _saveCredentials(email, password);
    } catch (e) {
      isAuth = false;
    }

    notifyListeners();
    return isAuth;
  }

  Future<void> reset() async {
    await logout();
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
  }

  Future<void> logout() async {
    isAuth = false;
    user = null;
    userConfiguration.isFirst = true;
    _saveCredentials(null, null);
    notifyListeners();
  }
}
