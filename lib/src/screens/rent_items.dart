import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:provider/provider.dart';

import '../models/mqtt_model.dart';
import '../models/shop.dart';
import '../routing.dart';
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
  Widget _buildMessageView(String rfid_code) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      child: Text(
        rfid_code,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final routeState = RouteStateScope.of(context);

    final state = Provider.of<MQTTModel>(context);

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
                      itemBuilder: (context, index) =>
                          _buildMessageView(state.message[index]),
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
                    // TODO: do http request, and clear rfids after!
                    print("Renting Items");
                    state.message
                        .clear(); // clean up list of rfids, for later reuse
                    routeState.go('/inventory_example');
                  }
                },
                label: Text('Rent Items'),
                icon: Icon(Icons.shopping_cart_checkout),
              ))
        ]));
  }
}
