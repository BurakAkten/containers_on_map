import 'package:containers/base/services/auth_service.dart';

class LoginService {
  Future<LoginResponse> login(String userName, String password) async {
    return await AuthService.instance.login(username: userName, password: password);
  }
}
