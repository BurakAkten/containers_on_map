import 'dart:async';
import 'package:containers/screens/login/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_base/flutter_project_base.dart';
import '../../../base/services/auth_service.dart' as base_auth;

class AuthViewModel extends BaseViewModel {
  final AuthService service;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = true, isUserValidated = true;
  String _userName = "", _password = "";
  bool _isLogin = true;

  AuthViewModel({required this.service});

  @override
  FutureOr<void> init() {
    usernameController.addListener(() {
      isUserValidated = true;
      reloadState();
    });
  }

  Future<base_auth.AuthResponse> auth() async {
    return isLogin ? await _login() : await _createAccount();
  }

  Future<base_auth.AuthResponse> _login() async {
    isLoading = true;
    var result = await service.login(_userName, _password);
    isUserValidated = result.isSuccess;
    isLoading = false;

    return result;
  }

  Future<base_auth.AuthResponse> _createAccount() async {
    isLoading = true;
    var result = await service.createAccount(_userName, _password);
    isUserValidated = result.isSuccess;
    isLoading = false;

    return result;
  }

  void changePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    reloadState();
  }

  void changeAuthType() {
    _isLogin = !_isLogin;
    reloadState();
  }

  //Setters
  set password(String value) {
    _password = value;
    reloadState();
  }

  set userName(String value) {
    _userName = value;
    reloadState();
  }

  //Getters
  bool get isLogin => _isLogin;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isButtonEnabled => _userName.isNotEmpty && _password.isNotEmpty;
  String get password => _password;
  String get userName => _userName;
}
