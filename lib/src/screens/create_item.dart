// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';

import '../models/inventory.dart';
import '../models/mqtt_model.dart';
import '../models/shop.dart';
import '../services/mqtt_service.dart';

class CreateItemScreen extends StatefulWidget {
  final ValueChanged<Item> onSubmit;
  final Shop shop;

  const CreateItemScreen({
    required this.onSubmit,
    required this.shop,
    super.key,
  });

  @override
  State<CreateItemScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<CreateItemScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  String chosenCategory = "BOOK";

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MQTTModel>(context);
    final _service = MQTTService(
      host: 'ws://apps.xmp.systems',
      port: 9011,
      topic: 'rfid-test',
      model: state,
    );
    _service.initializeMQTTClient();
    _service.connectMQTT();

    int length = state.message.length;
    String? rfid = null;
    if (length != 0) {
      rfid = state.message.last;
    } else {
      rfid = null;
    }

    return Scaffold(
      body: Center(
        child: Card(
          child: Container(
            constraints: BoxConstraints.loose(const Size(600, 600)),
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Add Item to Inventory of ${widget.shop.name}',
                    style: Theme.of(context).textTheme.headline5),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    rfid ?? 'Please scan item RFID',
                  ),
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  controller: _nameController,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text('Category'),
                      Container(width: 8),
                      DropdownButton<String>(
                        value: chosenCategory,
                        elevation: 16,
                        onChanged: (String? newValue) {
                          setState(() {
                            chosenCategory = newValue!;
                          });
                        },
                        // TODO: get these categories from db instead of hardcoding them
                        items: <String>[
                          "BOOK",
                          "TOOL",
                          "STATIONARY",
                          "ELECTRONIC"
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ]),
                TextField(
                    decoration: const InputDecoration(labelText: 'Description'),
                    controller: _descriptionController),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextButton(
                    onPressed: () async {
                      var nameOk = _nameController.text.isNotEmpty;
                      var rfidOk = (rfid != null);
                      if (nameOk && rfidOk) {
                        widget.onSubmit(Item.createNew(_nameController.text,
                            _descriptionController.text, chosenCategory, rfid));
                      } else if (!nameOk) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Please provide a name'),
                        ));
                      } else if (!rfidOk) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Please scan the RFID of the item'),
                        ));
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(1),
                  child: Link(
                    uri: Uri.parse('/inventory_example'),
                    builder: (context, followLink) => TextButton(
                      onPressed: followLink,
                      child: const Text('Back to inventory'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
