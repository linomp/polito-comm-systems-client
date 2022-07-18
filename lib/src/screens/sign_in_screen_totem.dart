import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

import '../models/credentials.dart';
import '../models/mqtt_model.dart';
import '../routing.dart';
import '../services/mqtt_service.dart';

class Sign_in_totem_screen extends StatefulWidget {
  final ValueChanged<Credentials> onSignIn;

  const Sign_in_totem_screen({
    required this.onSignIn,
    super.key,
  });

  @override
  State<Sign_in_totem_screen> createState() => Sign_in_totem_state();
}

class Sign_in_totem_state extends State<Sign_in_totem_screen> {
  // Holds the text that user typed.
  String text = '';

  // CustomLayoutKeys _customLayoutKeys;
  // True if shift enabled.
  bool shiftEnabled = false;

  // is true will show the numeric keyboard.
  bool isNumericMode = true;

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
        title: Text(' Totem sign in '),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                rfid,
              ),
            ),
            Center(
              child: TextField(
                decoration: const InputDecoration(labelText: 'Pin'),
                obscureText: true,
                controller: _controllerText,
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Container(
              color: Colors.lightBlue,
              child: VirtualKeyboard(
                  height: 200,
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          widget.onSignIn(Credentials(rfid, _controllerText.value.text));
          state.message.clear(); // clean up list of rfids, for later reuse
          routeState.go('/shoplist');
        },
        foregroundColor: Colors.black54,
        backgroundColor: Colors.white,
        label: Text('login in'),
        icon: Icon(Icons.login),
      ),
    );
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
