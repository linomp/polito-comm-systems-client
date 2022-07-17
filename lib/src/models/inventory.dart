import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Item {
  final String name;
  final String description;
  final int id;
  final int renter_user_id;
  final bool available_for_rent;
  final String category;
  final String rfid;

  const Item({
    required this.name,
    required this.id,
    required this.category,
    required this.description,
    required this.renter_user_id,
    required this.available_for_rent,
    required this.rfid,
  });

  factory Item.createNew(name, description, category, rfid) {
    return Item(
      name: name,
      id: -1,
      category: category,
      description: description,
      renter_user_id: -1,
      available_for_rent: true,
      rfid: rfid,
    );
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'],
      id: json['id'],
      category: json['category'],
      description: json['description'] ?? 'N/A',
      renter_user_id: (json['renter_user_id'] ?? -1).toInt(),
      available_for_rent: json['available_for_rent'] ?? false,
      rfid: json['rfid'] ?? 'N/A',
    );
  }

  // bool to string
  String available() {
    if (this.renter_user_id != -1) {
      if (this.available_for_rent == true) {
        return 'Available';
      } else {
        return 'Rented by user_id : ' + this.renter_user_id.toString();
      }
    } else if (this.available_for_rent && this.renter_user_id == -1) {
      if (this.available_for_rent) {
        return 'Available';
      } else {
        return 'Not Available';
      }
    } else {
      return ' Available';
    }
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
