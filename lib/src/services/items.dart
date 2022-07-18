import 'dart:convert';

import 'package:http/http.dart' as http;

import '../app.dart';
import '../models/inventory.dart';
import '../models/token.dart';

Future<bool> rent_items(List<String> rfids) async {
  Token? token;

  //String token_str = (await storage.read(key: TOKEN_STORAGE_KEY))!;
  String token_str = (await storage.getItem(TOKEN_STORAGE_KEY))!;
  token = Token(token_type: "Bearer", access_token: token_str);

  final response = await http.post(
    Uri.parse(SERVER_IP + '/item/rent_items'),
    headers: {
      "Content-Type": "application/json",
      "Authorization": token.token_type + " " + token.access_token,
    },
    body: jsonEncode(rfids),
  );

  return (response.statusCode == 200);
}

Future<bool> return_items(List<String> rfids) async {
  Token? token;

  //String token_str = (await storage.read(key: TOKEN_STORAGE_KEY))!;
  String token_str = (await storage.getItem(TOKEN_STORAGE_KEY))!;
  token = Token(token_type: "Bearer", access_token: token_str);

  final response = await http.post(
    Uri.parse(SERVER_IP + '/item/return_items'),
    headers: {
      "Content-Type": "application/json",
      "Authorization": token.token_type + " " + token.access_token,
    },
    body: jsonEncode(rfids),
  );

  return (response.statusCode == 200);
}

Future<bool> do_create_item(cst_id, Item item) async {
  Token? token;

  //String token_str = (await storage.read(key: TOKEN_STORAGE_KEY))!;
  String token_str = (await storage.getItem(TOKEN_STORAGE_KEY))!;
  token = Token(token_type: "Bearer", access_token: token_str);

  final response = await http.post(
    Uri.parse(SERVER_IP + '/item/add_item?cst_id=' + cst_id.toString()),
    headers: {
      "Content-Type": "application/json",
      "Authorization": token.token_type + " " + token.access_token,
    },
    body: jsonEncode({
      "name": item.name,
      "description": item.description,
      "category": item.category,
      "rfid": item.rfid
    }),
  );

  return (response.statusCode == 200);
}

Future<List<Item>> fetchInventory(cst_id) async {
  Token? token;

  //String token_str = (await storage.read(key: TOKEN_STORAGE_KEY))!;
  String token_str = (await storage.getItem(TOKEN_STORAGE_KEY))!;
  token = Token(token_type: "Bearer", access_token: token_str);

  final response = await http.get(
      Uri.parse(
          SERVER_IP + '/item/all_items_from_cst?cst_id=' + cst_id.toString()),
      headers: {
        "Authorization": token.token_type + " " + token.access_token,
      });

  if (response.statusCode == 200) {
    var list = json.decode(response.body) as List;
    return list.map((i) => Item.fromJson(i)).toList();
  } else {
    throw Exception('Failed to load items');
  }
}

Future<List<Item>> get_user_rented_items() async {
  Token? token;

  //String token_str = (await storage.read(key: TOKEN_STORAGE_KEY))!;
  String token_str = (await storage.getItem(TOKEN_STORAGE_KEY))!;
  token = Token(token_type: "Bearer", access_token: token_str);

  final response = await http
      .get(Uri.parse(SERVER_IP + '/users/get_my_rented_items'), headers: {
    "Authorization": token.token_type + " " + token.access_token,
  });

  if (response.statusCode == 200) {
    var list = json.decode(response.body) as List;
    return list.map((i) => Item.fromJson(i)).toList();
  } else {
    throw Exception('Failed to load items');
  }
}
