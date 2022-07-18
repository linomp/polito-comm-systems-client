import 'package:bookstore/src/models/rfid-setup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

import '../models/mqtt_model.dart';
import '../routing.dart';
import '../services/mqtt_service.dart';

class SetupRFIDTotemScreen extends StatefulWidget {
  @override
  State<SetupRFIDTotemScreen> createState() => SetupRFIDTotemScreenState();
}

class SetupRFIDTotemScreenState extends State<SetupRFIDTotemScreen> {
  // Holds the text that user typed.
  String text = '';

  // CustomLayoutKeys _customLayoutKeys;
  // True if shift enabled.
  bool shiftEnabled = false;

  // is true will show the numeric keyboard.
  bool isNumericMode = false;

  //late TextEditingController _controllerText;
  final _rfidText = TextEditingController();
  final _controllerText = TextEditingController();

  @override
  void initState() {
    // _customLayoutKeys = CustomLayoutKeys();
    //_controllerText = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final rfidData = Provider.of<RfidSetupModel>(context, listen: false);
    rfidData.init();

    final routeState = RouteStateScope.of(context);

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
    String rfid = '';
    if (length != 0) {
      rfid = state.message.last;
      print(rfid);
    } else {
      rfid = 'Please scan your RFID';
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('RFID and PIN Setup'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(labelText: 'Email'),
                obscureText: false,
                controller: _controllerText,
              ),
              Expanded(
                child: Container(),
              ),
              Container(
                color: Colors.lightBlue,
                child: VirtualKeyboard(
                    height: 250,
                    width: 500,
                    textColor: Colors.white,
                    textController: _controllerText,
                    //customLayoutKeys: _customLayoutKeys,
                    defaultLayouts: [
                      VirtualKeyboardDefaultLayouts.Arabic,
                      VirtualKeyboardDefaultLayouts.English
                    ],
                    //reverseLayout :true,
                    type: isNumericMode
                        ? VirtualKeyboardType.Numeric
                        : VirtualKeyboardType.Alphanumeric,
                    onKeyPress: _onKeyPress),
              )
            ],
          ),
        ),
        floatingActionButton: Padding(
            padding: const EdgeInsets.all(4),
            child: FloatingActionButton.extended(
              onPressed: () {
                rfidData.setMail(_controllerText.text);
                routeState.go('/setup-rfid2');
              },
              foregroundColor: Colors.black54,
              backgroundColor: Colors.white,
              label: Text('Next'),
              icon: Icon(Icons.arrow_right),
            )));
  }

  /// Fired when the virtual keyboard key is pressed.
  _onKeyPress(VirtualKeyboardKey key) {
    if (key.keyType == VirtualKeyboardKeyType.String) {
      text = text + (shiftEnabled ? key.capsText : key.text)!;
    } else if (key.keyType == VirtualKeyboardKeyType.Action) {
      switch (key.action) {
        case VirtualKeyboardKeyAction.Backspace:
          if (text.length == 0) return;
          text = text.substring(0, text.length - 1);
          break;
        case VirtualKeyboardKeyAction.Return:
          text = text + '\n';
          break;
        case VirtualKeyboardKeyAction.Space:
          text = text + (key.text)!;
          break;
        case VirtualKeyboardKeyAction.Shift:
          shiftEnabled = !shiftEnabled;
          break;
        default:
      }
    }
    // Update the screen
    setState(() {});
  }
}
