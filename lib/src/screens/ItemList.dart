import 'package:bookstore/src/models/inventory.dart';
import 'package:flutter/material.dart';

import '../data.dart';
import '../screens/shops.dart';
import '../models/inventory.dart';

class ItemList extends StatelessWidget {
  final List<Item> Items;
  final ValueChanged<Item>? onTap;

  const ItemList({
    required this.Items,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) => ListView.builder(
    itemCount: Items.length,
    itemBuilder: (context, index) => ListTile(
      title: Text(
        Items[index].name,
      ),
      subtitle: Text(
        Items[index].category,
      ),
      onTap: onTap != null ? () => onTap!(Items[index]) : null,
    ),
  );
}