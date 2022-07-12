import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Item {
  final String name;
  final String description;
  final int id;
  final int costumer_id;
  final String category;
  final String rfid;

  const Item({
    required this.name,
    required this.id,
    required this.category,
    required this.description,
    required this.costumer_id,
    required this.rfid,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'],
      id: json['id'],
      category: json['category'],
      description: json['description'],
      costumer_id: json['costumer_id'],
      rfid: json['rfid'],
    );
  }
}

class InventoryModel extends ChangeNotifier {
  final List<Item> _items = [];

  UnmodifiableListView<Item> get items => UnmodifiableListView(_items);
  void addAll(List<Item> item) {
    _items.addAll(item);
    notifyListeners();
  }
  void removeAll() {
    _items.clear();
    notifyListeners();
  }
}
