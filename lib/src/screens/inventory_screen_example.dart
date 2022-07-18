// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:bookstore/src/constants.dart';
import 'package:flutter/material.dart';

import '../models/inventory.dart';
import '../models/shop.dart';
import '../routing.dart';
import '../services/items.dart';
import 'ItemList.dart';

class InventoryScreen extends StatefulWidget {
  final ShopModel shopModel;

  const InventoryScreen({
    super.key,
    required this.shopModel,
  });

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  late Future<List<Item>> futureInventory;

  @override
  void initState() {
    super.initState();
    var cst_id = widget.shopModel.shop!.id;
    futureInventory = fetchInventory(cst_id);
  }

  @override
  Widget build(BuildContext context) {
    final routeState = RouteStateScope.of(context);
    if (widget.shopModel.shop == null) {
      routeState.go('/shoplist');
    }

    return Scaffold(
      appBar:
          AppBar(title: Text("Inventory of ${widget.shopModel.shop!.name}")),
      body: Center(
        child: FutureBuilder<List<Item>>(
          future: futureInventory,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // It turned out easier to define the full onTap logic right here... this way we have access to routeState (for redirecting to the inventory screen)
              // and context, for saving selected shop to app state.
              return ItemList(
                  Items: snapshot.data!,
                  onTap: (Item item) {
                    // set the chosen shop as the current shop in the global state
                    // add button to add item to cart
                    // set the chosen item as the current item in the global state
                    // Provider.of<ShopModel>(context, listen: false).set(Shop(
                    //     id: shop.id,
                    //     name: shop.name,
                    //     category: shop.category));

                    // navigate to the "inventory" screen
                    routeState.go('/item_screen');
                  });
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton:
          (widget.shopModel.shop!.userRoleInShop != CLIENT_ROLE)
              ? FloatingActionButton.extended(
                  onPressed: () {
                    routeState.go('/items/create');
                  },
                  label: Text('Add Item to inventory'),
                  icon: Icon(Icons.add),
                )
              : Container(),
    );
  }

  RouteState get _routeState => RouteStateScope.of(context);

  // void _handleBookTapped(Book book) {
  //   _routeState.go('/book/${book.id}');
  // }
}
