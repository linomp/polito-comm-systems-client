// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data.dart';
import '../models/shop.dart';
import '../routing.dart';
import '../widgets/book_list.dart';
import 'ItemList.dart';
import '../models/inventory.dart';
import '../app.dart';
import 'package:http/http.dart' as http;









Future<List<Item>> fetchInventory(cst_id) async {


  print ( 'customer is : $cst_id');



  final response = await http
      .get(Uri.parse(SERVER_IP+'/item/all_items_from_cst?cst_id='+cst_id.toString()));



  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var list = json.decode(response.body) as List;
    return list.map((i) => Item.fromJson(i)).toList();


  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}


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
  late Future<List<Item>> futureInventory;


  @override
  void initState() {
    super.initState();

    // TODO: do the get request to get the list of items...
    // I think we can actually forget about putting the items in the global app state
    // ... just contact the server every time we are on this page. This may actually be better, to show always the latest data!

    var cst_id = widget.shopModel.shop!.id;
    futureInventory = fetchInventory(cst_id);
    print (futureInventory);
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
      // body: BookList(
      //   books: libraryInstance.allBooks,
      //   onTap: _handleBookTapped,
      // ),
      body: Center(
        child: FutureBuilder<List<Item>>(
          future: futureInventory,
          builder: (context, snapshot){
            if (snapshot.hasData)
            {
              // It turned out easier to define the full onTap logic right here... this way we have access to routeState (for redirecting to the inventory screen)
              // and context, for saving selected shop to app state.
              return ItemList(Items:snapshot.data!,
                  onTap: (Item item){
                    // set the chosen shop as the current shop in the global state
                    //Provider.of<ShopModel>(context, listen: false).set(Shop(id: shop.id, name: shop.name, category: shop.category));
                    // get shop id
                    //int shop_id = shop.id;

                    // navigate to the "inventory" screen
                    // routeState.go('/inventory');
                  });
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  RouteState get _routeState => RouteStateScope.of(context);

  void _handleBookTapped(Book book) {
    _routeState.go('/book/${book.id}');
  }


}
