import 'package:flutter/foundation.dart';
import 'package:driver_app/domain/user.dart';

class UserProvider with ChangeNotifier {
  User _user = User();

  get user {
    return _user;
  }

  set user(User user) {
    _user = user;
    notifyListeners();
  }
}
