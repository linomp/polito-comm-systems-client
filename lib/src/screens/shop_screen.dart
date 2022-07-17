import 'dart:async';

import 'package:bookstore/src/screens/shops_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/shop.dart';
import '../routing/route_state.dart';
import '../services/shops.dart';

class ShopsScreen extends StatefulWidget {
  const ShopsScreen({super.key});
  @override
  State<ShopsScreen> createState() => ShopsContent();
}

class ShopsContent extends State<ShopsScreen> {
  late Future<List<Shop>> futureShops;

  @override
  void initState() {
    super.initState();

    futureShops = fetchShops();
  }

  @override
  Widget build(BuildContext context) {
    final routeState = RouteStateScope.of(context);

    return MaterialApp(
      title: 'My Shops',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Choose a shop'),
        ),
        body: Center(
          child: FutureBuilder<List<Shop>>(
            future: futureShops,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // It turned out easier to define the full onTap logic right here... this way we have access to routeState (for redirecting to the inventory screen)
                // and context, for saving selected shop to app state.
                return ShopsList(
                    shops: snapshot.data!,
                    onTap: (Shop shop) {
                      // set the chosen shop as the current shop in the global state
                      Provider.of<ShopModel>(context, listen: false).set(Shop(
                          id: shop.id,
                          name: shop.name,
                          category: shop.category));

                      // navigate to the "inventory" screen
                      routeState.go('/inventory_example');
                    });
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            routeState.go('/shop_add');
          },
          label: Text('add shop to my account'),
          icon: Icon(Icons.add),
        ),
      ),
    );
  }
}
