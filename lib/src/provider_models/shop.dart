import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Shop {
  final int id;
  final String name;
  final String category;

  const Shop({
    required this.name,
    required this.id,
    required this.category,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      name: json['name'],
      id: json['id'],
      category: json['category'],
    );
  }
}

class ShopModel extends ChangeNotifier {
  Shop? _shop;

  Shop? get user => _shop;

  void set(Shop shop) {
    _shop = shop;
    print("ShopModel set shop: ${shop.name}");
    notifyListeners();
  }
  void reset() {
    _shop = null;
    notifyListeners();
  }
}
