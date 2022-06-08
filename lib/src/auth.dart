// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

import 'dart:async';
import 'dart:convert';

import '../main.dart';

/// A mock authentication service
class BookstoreAuth extends ChangeNotifier
{
  bool _signedIn = false;

  bool get signedIn => _signedIn;

  Future<Token?> get_token(user, pass) async
  {
  final response = await http.post(
    Uri.parse(SERVER_IP+'/token'),
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    },
    encoding: Encoding.getByName('utf-8'),
    body: {"username": user, "password": pass},
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Token.fromJson(jsonDecode(response.body));
  }
  else
  {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    //throw Exception('Failed to create album.');
    return null;
  }
}


  Future<void> signOut() async
  {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    // Sign out.
    _signedIn = false;
    storage.delete(key: "jwt");
    notifyListeners();
  }

  Future<bool> signIn(String username, String password) async
  {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    //http post request

    var result = await get_token(username, password);
    if(  result != null )
      {
        // Sign in. Allow any password.
        _signedIn = true;
        storage.write(key: "jwt", value: result.access_token );
        log('token: $result');
      }
    else
      {
        _signedIn = false;
        log('error logging in :');
      }


    notifyListeners();
    return _signedIn;
  }

  @override
  bool operator ==(Object other) =>
      other is BookstoreAuth && other._signedIn == _signedIn;

  @override
  int get hashCode => _signedIn.hashCode;
}

class BookstoreAuthScope extends InheritedNotifier<BookstoreAuth> {
  const BookstoreAuthScope({
    required super.notifier,
    required super.child,
    super.key,
  });

  static BookstoreAuth of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<BookstoreAuthScope>()!
      .notifier!;
}



class Token {
  final String access_token;
  final String token_type;

  const Token({required this.access_token, required this.token_type});

  factory Token.fromJson(Map<String, dynamic> json)
  {
    return Token(
      access_token: json['access_token'],
      token_type: json['token_type'],
    );
  }

  @override
  String toString()
  {
    return access_token;
  }
}