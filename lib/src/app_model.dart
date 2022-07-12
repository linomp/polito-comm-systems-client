import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ShopModel extends ChangeNotifier {
  final List<Shop> shops = [];

  UnmodifiableListView<Shop> get items => UnmodifiableListView(shops);
  void add(Shop item) {
    shops.add(item);
    notifyListeners();
  }
  void removeAll() {
    shops.clear();
    notifyListeners();
  }
}

class Shop {
  String name = "";
  Icon? icon;
}