import 'package:containers/base/services/auth_service.dart' as auth;

class AuthService {
  Future<auth.AuthResponse> login(String userName, String password) async {
    return await auth.AuthService.instance.login(username: userName, password: password);
  }

  Future<auth.AuthResponse> createAccount(String userName, String password) async {
    return await auth.AuthService.instance.createAccount(username: userName, password: password);
  }
}
