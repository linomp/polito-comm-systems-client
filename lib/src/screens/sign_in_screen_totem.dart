import 'package:flutter/material.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

import '../models/credentials.dart';
import '../routing.dart';



class Sign_in_totem_screen extends StatefulWidget {
  final ValueChanged<Credentials> onSignIn;

  const Sign_in_totem_screen({
    required this.onSignIn,
    super.key,
  });

  @override

  State<Sign_in_totem_screen> createState() =>Sign_in_totem_state();
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
    return Scaffold(
      appBar: AppBar(
        title: Text(' Totem sign in '),
      ),
      body: Center(
        child:
        Column(
          children: <Widget>[

            TextField(
              decoration: const InputDecoration(labelText: 'Scan RFID'),
              obscureText: false,
              controller: _rfidText,

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
                  //width: 500,
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
      floatingActionButton:FloatingActionButton.extended(
        onPressed: () {
          // when clicked on floating action button prompt to create user
          //
          //print("clicked on floating action button");
          widget.onSignIn(Credentials(
              _rfidText.value.text,
              _controllerText.value.text));

          //http resquset to sign in
          routeState.go('/shop');
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