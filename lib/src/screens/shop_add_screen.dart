import 'dart:async';
import 'dart:convert';

import 'package:bookstore/src/screens/shops_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../app.dart';
import '../models/shop.dart';
import '../models/token.dart';
import '../routing/route_state.dart';

// send token in url header
Future<List<Shop>> fetchShops() async {
  final response = await http.get(
    Uri.parse(SERVER_IP + '/customers/all_cst'),
  );
  if (response.statusCode == 200) {
    var list = json.decode(response.body) as List;
    return list.map((i) => Shop.fromJson(i)).toList();
  } else {
    throw Exception('Failed to load shops');
  }
}

class addShopsScreen extends StatefulWidget {
  const addShopsScreen({super.key});

  //final Token token;

  // const ShopsScreen({
  //   super.key,
  //   required this.token,
  // });

  @override
  State<addShopsScreen> createState() => addShopsContent();
}

class addShopsContent extends State<addShopsScreen> {
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
      title: 'Add new shop to your account',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Choose a shop to add to your account'),
        ),
        body: Center(
          child: FutureBuilder<List<Shop>>(
            future: futureAlbums,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // It turned out easier to define the full onTap logic right here... this way we have access to routeState (for redirecting to the inventory screen)
                // and context, for saving selected shop to app state.
                return ShopsList(
                    shops: snapshot.data!,
                    onTap: (Shop shop) async {
                      // set the chosen shop as the current shop in the global state
                      //http post to add shop to customer

                      // add a new shop to the list of shops
                      Token? token;

                      String token_str =
                          (await storage.read(key: TOKEN_STORAGE_KEY))!;
                      token =
                          Token(token_type: "Bearer", access_token: token_str);

                      final response = await http.post(
                          Uri.parse(SERVER_IP +
                              '/users/associate_to_cst?costumer_id=' +
                              shop.id.toString()),
                          headers: {
                            "Authorization":
                                token.token_type + " " + token.access_token,
                          });

                      // // navigate to the "inventory" screen
                      await routeState.go('/shoplist');
                    });
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
