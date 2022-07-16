import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/mqtt_model.dart';
import '../services/mqtt_service.dart';

class RfidClientScreen extends StatefulWidget {
  final String title = "Rfid Client";

  @override
  _MyRfidScreenState createState() => _MyRfidScreenState();
}

class _MyRfidScreenState extends State<RfidClientScreen> {
  Widget _buildMessageView(String rfid_code) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      decoration: BoxDecoration(
        color: Colors.pink[200],
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
      ),
      margin: EdgeInsets.only(top: 8.0, bottom: 8.0, right: 80.0),
      child: Text(
        rfid_code,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MQTTModel>(context);
    final _service = MQTTService(
      host: 'apps.xmp.systems',
      port: 1883,
      topic: 'rfid-test',
      model: state,
    );
    _service.initializeMQTTClient();
    _service.connectMQTT();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.blue,
        appBar: AppBar(
          elevation: 0.0,
          toolbarHeight: 80.0,
          title: Text('Messages'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0)),
                ),
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 25.0),
                  itemCount: state.message.length,
                  itemBuilder: (context, index) =>
                      _buildMessageView(state.message[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
