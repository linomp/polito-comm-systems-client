import 'dart:async';
import 'dart:convert';

import 'package:bookstore/src/models/user.dart';
import 'package:bookstore/src/screens/shops_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../app.dart';
import '../models/shop.dart';
import '../routing/route_state.dart';
import '../models/token.dart';


// send token in url header
Future<List<Shop>> fetchShops() async {

  Token? token;

  String token_str = (await storage.read(key: TOKEN_STORAGE_KEY))!;
  token = Token(token_type: "Bearer", access_token: token_str);

  final response = await http.get(Uri.parse(SERVER_IP + '/users/view_my_cst'),
      headers: {
        "Authorization": token.token_type + " " + token.access_token,
      });
  if (response.statusCode == 200) {
    var list = json.decode(response.body) as List;
    return list.map((i) => Shop.fromJson(i)).toList();
  } else {
    throw Exception('Failed to load shops');
  }
}

class ShopsScreen extends StatefulWidget {
  const ShopsScreen({super.key});
  //final Token token;

  // const ShopsScreen({
  //   super.key,
  //   required this.token,
  // });

  @override
  State<ShopsScreen> createState() => ShopsContent();
}

class ShopsContent extends State<ShopsScreen> {
  late Future<List<Shop>> futureAlbums;




  @override
  void initState() {
    super.initState();

    futureAlbums = fetchShops();

  }

  @override
  Widget build(BuildContext context) {
    final routeState = RouteStateScope.of(context);

    return MaterialApp(
      title: 'Shop list',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Choose a shop'),
        ),
        body: Center(

          child: FutureBuilder<List<Shop>>(
            future: futureAlbums,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // It turned out easier to define the full onTap logic right here... this way we have access to routeState (for redirecting to the inventory screen)
                // and context, for saving selected shop to app state.
                return ShopsList(
                    albums: snapshot.data!,
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

        floatingActionButton:FloatingActionButton.extended(
          onPressed: () {
            // when clicked on floating action button prompt to create user
          //
            print("clicked on floating action button");
            routeState.go('/shop_add');
          },
          label: Text('add shops'),
          icon: Icon(Icons.add),
        ),
      ),
    );
  }
}