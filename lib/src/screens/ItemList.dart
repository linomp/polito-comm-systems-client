import 'package:bookstore/src/models/inventory.dart';
import 'package:flutter/material.dart';

import '../models/inventory.dart';

class ItemList extends StatelessWidget {
  final List<Item> Items;
  final ValueChanged<Item>? onTap;

  const ItemList({
    required this.Items,
    this.onTap,
    super.key,
  });

  String intToString(int i) {
    return i.toString();
  }

  @override
  Widget build(BuildContext context) => ListView.builder(
        itemCount: Items.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(
            intToString(index) + ': ' + Items[index].name,
          ),
          subtitle: Text(
            'category : ' +
                Items[index].category +
                '       ' +
                Items[index].available(),
          ),
          onTap: onTap != null ? () => onTap!(Items[index]) : null,
        ),
      );
}
