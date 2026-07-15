import '../../models/user_model.dart';
import '../../services/auth_service.dart';

class LoginController {
  final AuthService _authService = AuthService();

  UserModel login(String username) {
    return _authService.login(username);
  }
}