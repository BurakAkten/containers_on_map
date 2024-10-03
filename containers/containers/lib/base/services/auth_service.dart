import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:containers/domain/dtos/user.dart';

class AuthService {
  static final AuthService _instance = AuthService._private();
  AuthService._private();

  static AuthService get instance => _instance;

  Future<AuthResponse> login({String? username, String? password}) async {
    if ([username, password].any((item) => item == null)) return AuthResponse.failure(message: "Error");

    try {
      var userDocs = (await FirebaseFirestore.instance.collection("users").where("username", isEqualTo: username).get()).docs;
      var users = User.listFromJson(userDocs.map((d) => d.data()).toList());
      var isUserExist = users.any((user) => user.password == password);
      return isUserExist ? AuthResponse.success() : AuthResponse.failure();
    } catch (e) {
      return AuthResponse.failure(message: e.toString());
    }
  }

  Future<AuthResponse> createAccount({String? username, String? password}) async {
    if ([username, password].any((item) => item == null)) return AuthResponse.failure(message: "Error");

    try {
      var userDocs = (await FirebaseFirestore.instance.collection("users").where("username", isEqualTo: username).get()).docs;
      var users = User.listFromJson(userDocs.map((d) => d.data()).toList());

      if (users.isNotEmpty) return AuthResponse.failure(message: "User exist.");
      var user = {"username": username!, "password": password!};
      await FirebaseFirestore.instance.collection("users").add(user);
      return AuthResponse.success();
    } catch (e) {
      return AuthResponse.failure(message: e.toString());
    }
  }
}

class AuthResponse {
  late bool isSuccess;
  String? errorMessage;

  AuthResponse.success() {
    isSuccess = true;
  }

  AuthResponse.failure({String message = "There is no such username!"}) {
    isSuccess = false;
    errorMessage = message;
  }
}
