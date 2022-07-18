import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RfidSetup {
  String? pin;
  String? mail;
  String? password;
  String? rfid;

  RfidSetup(this.mail, this.password, this.rfid, this.pin);
}

class RfidSetupModel extends ChangeNotifier {
  RfidSetup? _rfidData;

  RfidSetup? get data => _rfidData;

  void init() {
    _rfidData = RfidSetup("", "", "", "");
  }

  void set(RfidSetup data) {
    _rfidData = data;
    print(
        "Current RfidSetup in app state set to: \{id: email: ${data.mail}, password: ${data.password}, rfid: ${data.rfid}, pin: ${data.pin}\}");
    notifyListeners();
  }

  void setMail(String mail) {
    _rfidData!.mail = mail;
    notifyListeners();
  }

  void setPassword(String password) {
    _rfidData!.password = password;
    notifyListeners();
  }

  void setRfid(String rfid) {
    _rfidData!.rfid = rfid;
    notifyListeners();
  }

  void setPin(String pin) {
    _rfidData!.pin = pin;
    notifyListeners();
  }

  void reset() {
    _rfidData = null;
    notifyListeners();
  }
}
