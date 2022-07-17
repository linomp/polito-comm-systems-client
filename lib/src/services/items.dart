import 'dart:convert';

import 'package:http/http.dart' as http;

import '../app.dart';
import '../models/inventory.dart';

Future<Item?> do_create_item(cst_id, Item item) async {
  final response = await http.post(
    Uri.parse(SERVER_IP + '/item/add_item?cst_id=' + cst_id.toString()),
    headers: {
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "name": item.name,
      "description": item.description,
      "category": item.category,
      "rfid": item.rfid
    }),
  );

  print("Register - Response: " + response.body);

  if (response.statusCode == 200) {
    return Item.fromJson(jsonDecode(response.body));
  } else {
    return null;
  }
}
