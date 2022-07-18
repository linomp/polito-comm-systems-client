import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Shop {
  final int id;
  final String name;
  final String category;
  final String userRoleInShop;

  const Shop({
    required this.name,
    required this.id,
    required this.category,
    required this.userRoleInShop,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      name: json['name'],
      id: json['id'],
      category: json['category'],
      userRoleInShop: json['role'] ?? 'Not set',
    );
  }
}

class ShopModel extends ChangeNotifier {
  Shop? _shop;

  Shop? get shop => _shop;

  void set(Shop shop) {
    _shop = shop;
    // print(
    //     "ShopModel set shop: {id:${shop.id}, name:${shop.name}, category:${shop.category}, role:${shop.userRoleInShop}}");
    notifyListeners();
  }

  void reset() {
    _shop = null;
    notifyListeners();
  }
}
