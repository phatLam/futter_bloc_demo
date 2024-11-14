import 'package:uuid/uuid.dart';

import 'models/models.dart';

class UserRepo {
  User? _user;

  Future<User?> getUser() async {
    if (_user != null) _user;
    return Future.delayed(
      Duration(milliseconds: 300),
        () => User(const Uuid().v4())
    );
  }
}
