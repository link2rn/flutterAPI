import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:apilab/bloc/base_bloc.dart';
import 'package:apilab/service/LoginService.dart';
import 'package:apilab/user.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationBloc extends BaseBloc {
  LoginService _loginService;

  User _user;
  User get user => _user;

  BehaviorSubject<bool> _isAuthenticated = BehaviorSubject();
  Stream<bool> get isAuthenticated => _isAuthenticated;

  BehaviorSubject<LoginState> _loginState =
      BehaviorSubject.seeded(LoginState.UNINITILIZED);
  Stream<LoginState> get loginState => _loginState;

  AuthenticationBloc() {
    _loginService = LoginService();
    isUserAuthenticated();
  }

  isUserAuthenticated() async {
    _user = await _loginService.getLoginUser();
    print(user);
    _isAuthenticated.add(_user != null);
  }

  saveUserInfo(User user) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (user == null) {
      sharedPreferences.remove("user-info");
    } else {
      sharedPreferences.setString("user-info", json.encode(user.toJson()));
    }
    isUserAuthenticated();
  }

  loginUser(String username, String password) async {
    try {
      _loginState.add(LoginState.LOADING);
      _user = await _loginService.loginUser(username, password);
      await saveUserInfo(user);
      _loginState.add(LoginState.SUCCESS);
    } catch (error) {
      print(error);
      String errorMessage = "";
      if (error is SocketException) {
        errorMessage = "Internet not available";
      } else {
        errorMessage = error.toString();
      }
            _loginState.add(LoginState.ERROR);

      _loginState.addError(errorMessage);
    }
  }

  logout() async {
    saveUserInfo(null);
  }

  @override
  void onDispose() {
    _isAuthenticated.close();
    _loginState.close();
  }
}

enum LoginState {
  UNINITILIZED,
  LOADING,
  SUCCESS,
  ERROR,
}
