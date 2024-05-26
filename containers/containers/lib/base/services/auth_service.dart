import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:containers/domain/dtos/user.dart';

class AuthService {
  static final AuthService _instance = AuthService._private();
  AuthService._private();

  static AuthService get instance => _instance;

  Future<LoginResponse> login({String? username, String? password}) async {
    if ([username, password].any((item) => item == null)) return LoginResponse.failure(message: "Error");

    try {
      var userDocs = (await FirebaseFirestore.instance.collection("users").where("username", isEqualTo: username).get()).docs;
      var users = User.listFromJson(userDocs.map((d) => d.data()).toList());
      var isUserExist = users.any((user) => user.password == password);
      return isUserExist ? LoginResponse.success() : LoginResponse.failure();
    } catch (e) {
      return LoginResponse.failure(message: e.toString());
    }
  }
}

class LoginResponse {
  late bool isSuccess;
  String? errorMessage;

  LoginResponse.success() {
    isSuccess = true;
  }

  LoginResponse.failure({String message = "There is no such username!"}) {
    isSuccess = false;
    errorMessage = message;
  }
}
