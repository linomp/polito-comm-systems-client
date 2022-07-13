
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class User {
  final int id;
  final String name;
  final String mail;
  final String rfid;
  final int pin;

  const User({
    required this.id,
    required this.name,
    required this.mail,
    required this.rfid,
    required this.pin,
  });

  factory User.fromJson(Map<String, dynamic> json)
  {
    return User(
      id: json['id'].toInt(),
      name: json['name'],
      mail: json['mail_adr'],
      // Source: https://stackoverflow.com/a/58913445/8522453
      rfid: json['rfid'] ?? 'Not set',
      pin: (json['pin'] ?? 0).toInt(),
    );
  }
}

class UserModel extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  void set(User user) {
    _user = user;
    print("Current User in app state set to: \{id: ${user.id}, name: ${user.name}, email: ${user.mail}, rfid: ${user.rfid}, pin: ${user.pin}\}");
    notifyListeners();
  }


  void reset() {
    _user = null;
    notifyListeners();
  }
}
