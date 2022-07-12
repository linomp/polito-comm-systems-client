import 'dart:async';
import 'dart:convert';

import 'package:bookstore/src/provider_models/inventory.dart';
import 'package:bookstore/src/screens/shops_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '/main.dart';
import '../provider_models/shop.dart';



Future<List<Shop>> fetchAlbum() async {
  final response = await http
      .get(Uri.parse(SERVER_IP+'/customers/all_cst'));


  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var list = json.decode(response.body) as List;
    return list.map((i) => Shop.fromJson(i)).toList();


  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}





class ShopsScreen extends StatefulWidget {
  const ShopsScreen({super.key});

  @override
  State<ShopsScreen> createState() => ShopsContent();
}

class ShopsContent extends State<ShopsScreen> {
  late Future<List<Shop>> futureAlbums;

  @override
  void initState() {
    super.initState();
    futureAlbums = fetchAlbum();
  }

  @override
  Widget build(BuildContext context)
  {
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
          builder: (context, snapshot){
            if (snapshot.hasData)
            {
              return ShopsList(albums:snapshot.data!,
                onTap: _handleShopTapped);
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

  void _handleShopTapped(Shop shop) {
    Fluttertoast.showToast(
        msg: 'you have chosen ${shop.name}',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        //timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.yellow);

    // set the chosen shop as the current shop in the global state
    Provider.of<ShopModel>(context, listen: false).set(Shop(id: shop.id, name: shop.name, category: shop.category));

    // do GET request for the inventory of the chosen shop

    // parse the raw json response into a List<Item> and save the received items in the InventoryModel

    // navigate to the "inventory" screen
    //_routeState.go('/book/${book.id}')
  }
}