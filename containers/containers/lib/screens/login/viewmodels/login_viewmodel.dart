import 'dart:async';
import 'package:containers/screens/login/login_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_base/flutter_project_base.dart';
import '../../../base/services/auth_service.dart';

class LoginViewModel extends BaseViewModel {
  final LoginService service;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = true, isUserValidated = true;
  String _userName = "", _password = "";

  LoginViewModel({required this.service});

  @override
  FutureOr<void> init() {
    usernameController.addListener(() {
      isUserValidated = true;
      reloadState();
    });
  }

  Future<LoginResponse> login() async {
    isLoading = true;
    var result = await service.login(_userName, _password);
    isUserValidated = result.isSuccess;
    isLoading = false;

    return result;
  }

  void changePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
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
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isButtonEnabled => _userName.isNotEmpty && _password.isNotEmpty;
  String get password => _password;
  String get userName => _userName;
}
