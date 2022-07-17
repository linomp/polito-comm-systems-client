// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

import '../models/inventory.dart';

class CreateItemScreen extends StatefulWidget {
  final ValueChanged<Item> onSubmit;

  const CreateItemScreen({
    required this.onSubmit,
    super.key,
  });

  @override
  State<CreateItemScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<CreateItemScreen> {
  final _nameController = TextEditingController();
  final _rfidController = TextEditingController();

  String chosenCategory = "BOOK";

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Card(
            child: Container(
              constraints: BoxConstraints.loose(const Size(600, 600)),
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Add Item to Inventory',
                      style: Theme.of(context).textTheme.headline4),
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
                      decoration: const InputDecoration(
                          labelText: 'RFID (Scan on Totem)'),
                      obscureText: true,
                      controller: _rfidController,
                      readOnly: true),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextButton(
                      onPressed: () async {
                        var nameOk = _nameController.text.isNotEmpty;
                        var categoryOk =
                            true; //_categoryController.text.isNotEmpty;
                        var rfidOk = true; //_rfidController.text.isNotEmpty;
                        if (nameOk && categoryOk && rfidOk) {
                          // TODO: replace this with actual data
                          widget.onSubmit(Item.createNew("newName",
                              "NewDescription", "NewCategory", "NewRfid"));
                        } else if (!nameOk) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Please provide a name'),
                          ));
                        } else if (!rfidOk) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Please provide an RFID'),
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
