import 'dart:convert';

import 'package:http/http.dart' as http;

import '../app.dart';
import '../models/shop.dart';
import '../models/token.dart';

Future<List<Shop>> fetchShops() async {
  Token? token;

  String token_str = (await storage.read(key: TOKEN_STORAGE_KEY))!;
  token = Token(token_type: "Bearer", access_token: token_str);

  final response =
      await http.get(Uri.parse(SERVER_IP + '/users/view_my_cst'), headers: {
    "Authorization": token.token_type + " " + token.access_token,
  });
  if (response.statusCode == 200) {
    var list = json.decode(response.body) as List;
    return list.map((i) => Shop.fromJson(i)).toList();
  } else {
    throw Exception('Failed to load shops');
  }
}
