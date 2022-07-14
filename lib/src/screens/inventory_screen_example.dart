// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data.dart';
import '../models/shop.dart';
import '../routing.dart';
import '../widgets/book_list.dart';

class InventoryScreen extends StatefulWidget {

  final ShopModel shopModel;

  const InventoryScreen({
    super.key,
    required this.shopModel,
  });

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen>{

  @override
  void initState() {
    super.initState();

    // TODO: do the get request to get the list of items...
    // I think we can actually forget about putting the items in the global app state
    // ... just contact the server every time we are on this page. This may actually be better, to show always the latest data!
  }

  @override
  Widget build(BuildContext context) {
    final routeState = RouteStateScope.of(context);
    if (widget.shopModel.shop == null) {
      routeState.go('/shoplist');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Inventory of ${widget.shopModel.shop!.name}")
      ),
      // TODO: use a FutureBuilder like in shops screen and show a loading indicator while the data is loading.
      body: BookList(
        books: libraryInstance.allBooks,
        onTap: _handleBookTapped,
      ),
    );
  }

  RouteState get _routeState => RouteStateScope.of(context);

  void _handleBookTapped(Book book) {
    _routeState.go('/book/${book.id}');
  }


}
