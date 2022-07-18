import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

bool compute_availability(Map<String, dynamic> json) {
  if (json.containsKey('renter_user_id') && json['renter_user_id'] != null) {
    return false;
  } else if (json.containsKey('available_for_rent') &&
      json['available_for_rent'] == false) {
    return false;
  }

  return true;
}

class Item {
  final String name;
  final String description;
  final int id;
  final int renter_user_id;
  final bool available_for_rent;
  final String category;
  final String rfid;
  final bool is_available;

  const Item({
    required this.name,
    required this.id,
    required this.category,
    required this.description,
    required this.renter_user_id,
    required this.available_for_rent,
    required this.rfid,
    this.is_available = true,
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
        is_available: compute_availability(json));
  }

  // define getter for available
  String available() {
    if (renter_user_id != -1) {
      return 'Rented by user_id : ' + this.renter_user_id.toString();
    }

    if (is_available) {
      return 'Available';
    } else {
      return 'Not Available';
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
