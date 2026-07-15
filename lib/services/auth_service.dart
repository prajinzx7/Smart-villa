import '../models/user_model.dart';

class AuthService {
  UserModel login(String username) {
    return UserModel(username: username);
  }
}