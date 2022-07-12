import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Item {
  String name = "";
  String category = "";
  Icon? icon;
}

class InventoryModel extends ChangeNotifier {
  final List<Item> _items = [];

  UnmodifiableListView<Item> get items => UnmodifiableListView(_items);
  void add(Item item) {
    _items.add(item);
    notifyListeners();
  }
  void removeAll() {
    _items.clear();
    notifyListeners();
  }
}
