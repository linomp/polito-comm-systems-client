import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:provider/provider.dart';

import '../models/inventory.dart';
import '../models/mqtt_model.dart';
import '../models/shop.dart';
import '../routing.dart';
import '../services/items.dart';
import '../services/mqtt_service.dart';

class RentItemsScreen extends StatefulWidget {
  final ShopModel shopModel;

  const RentItemsScreen({
    super.key,
    required this.shopModel,
  });

  @override
  _MyRentItemsScreenState createState() => _MyRentItemsScreenState();
}

class _MyRentItemsScreenState extends State<RentItemsScreen> {
  Widget _buildMessageView(String rfid_code, Item? item) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      child: Row(children: [
        Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Text(
              rfid_code,
            )),
        Text((item != null) ? item.name : "Item not found in this shop"),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final routeState = RouteStateScope.of(context);

    final state = Provider.of<MQTTModel>(context);

    final inventory = Provider.of<InventoryModel>(context, listen: false).items;

    final _service = MQTTService(
      host: 'ws://apps.xmp.systems',
      port: 9011,
      topic: 'rfid-test',
      model: state,
    );
    _service.initializeMQTTClient();
    Future<MqttClientConnectionStatus?> futureConnection =
        _service.connectMQTT();
    return Scaffold(
        appBar: AppBar(
          title: Text('Rent Items from ${widget.shopModel.shop!.name}'),
        ),
        body: Center(
            child: FutureBuilder<MqttClientConnectionStatus?>(
                future: futureConnection,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      padding: EdgeInsets.only(top: 5.0),
                      itemCount: state.message.length,
                      itemBuilder: (context, index) => _buildMessageView(
                          state.message[index],
                          searchInInventoryCopy(
                              state.message[index], inventory)),
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const CircularProgressIndicator();
                })),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          Padding(
              padding: const EdgeInsets.all(4),
              child: FloatingActionButton.extended(
                onPressed: () {
                  // show a toast if state.message is empty
                  state.message.clear();
                  setState(() {});
                },
                label: Text('Reset'),
                icon: Icon(Icons.delete),
              )),
          Padding(
              padding: const EdgeInsets.all(4),
              child: FloatingActionButton.extended(
                onPressed: () {
                  // show a toast if state.message is empty
                  if (state.message.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Scan Item RFIDs on the Totem'),
                      ),
                    );
                  } else {
                    print("Renting Items");
                    List<String> filtered = state.message
                        .where((element) =>
                            searchInInventoryCopy(element, inventory) != null)
                        .toList();
                    rent_items(filtered).then((success) => {
                          if (success)
                            {
                              state.message.clear(),
                              routeState.go('/inventory_example')
                            }
                          else
                            {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error renting items'),
                                ),
                              )
                            }
                        });
                  }
                },
                label: Text('Rent Items'),
                icon: Icon(Icons.shopping_cart_checkout),
              ))
        ]));
  }

  Item? searchInInventoryCopy(String rfid, List<Item> items) {
    for (var item in items) {
      if (item.rfid == rfid) {
        return item;
      }
    }
    return null;
  }
}
