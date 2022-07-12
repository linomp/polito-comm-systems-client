
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class User {
  int id=0;
  String name = "";
  String mail="";
  String rfid="";
}

class UserModel extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  void set(User user) {
    _user = user;
    notifyListeners();
  }


  void reset() {
    _user = null;
    notifyListeners();
  }
}
