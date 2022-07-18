import 'package:flutter/cupertino.dart';

class MQTTModel with ChangeNotifier {
  var rfids = <String>[];

  List<String> get message => rfids;

  void addMessage(String message) {
    // add only if not present in list
    if (!rfids.contains(message)) {
      rfids.add(message);
    } else {
      print("rfid ${message} already present");
    }

    notifyListeners();
  }

  void clear() {
    rfids.clear();
    notifyListeners();
  }
}
