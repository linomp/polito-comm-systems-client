import 'package:flutter/cupertino.dart';

class MQTTModel with ChangeNotifier {
  var rfids = <String>[];

  List<String> get message => rfids;

  void addMessage(String message) {
    rfids.add(message);
    notifyListeners();
  }
}
