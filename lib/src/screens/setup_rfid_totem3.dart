import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

import '../models/mqtt_model.dart';
import '../models/rfid-setup.dart';
import '../routing.dart';
import '../services/mqtt_service.dart';

class SetupRFIDTotemScreen3 extends StatefulWidget {
  final ValueChanged<RfidSetup> onSubmit;

  const SetupRFIDTotemScreen3({
    required this.onSubmit,
    super.key,
  });

  @override
  State<SetupRFIDTotemScreen3> createState() => SetupRFIDTotemScreen3State();
}

class SetupRFIDTotemScreen3State extends State<SetupRFIDTotemScreen3> {
  // Holds the text that user typed.
  String pin = '';

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
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  rfid,
                ),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Pin'),
                obscureText: true,
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
                print(
                    "Sending rfid data: ${rfidData.data!.mail}, ${rfidData.data!.password}, ${pin}, ${rfid}");
                widget.onSubmit(RfidSetup(
                    rfidData.data!.mail, rfidData.data!.password, rfid, pin));
                routeState.go('/signin');
              },
              foregroundColor: Colors.black54,
              backgroundColor: Colors.white,
              label: Text('Submit'),
              icon: Icon(Icons.check),
            )));
  }

  /// Fired when the virtual keyboard key is pressed.
  _onKeyPress(VirtualKeyboardKey key) {
    if (key.keyType == VirtualKeyboardKeyType.String) {
      pin = pin + (shiftEnabled ? key.capsText : key.text)!;
    } else if (key.keyType == VirtualKeyboardKeyType.Action) {
      switch (key.action) {
        case VirtualKeyboardKeyAction.Backspace:
          if (pin.length == 0) return;
          pin = pin.substring(0, pin.length - 1);
          break;
        case VirtualKeyboardKeyAction.Return:
          pin = pin + '\n';
          break;
        case VirtualKeyboardKeyAction.Space:
          pin = pin + (key.text)!;
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
