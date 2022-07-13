// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:developer';

import 'dart:async';
import 'dart:convert';

import 'app.dart';
import 'models/token.dart';
import 'models/user.dart';

// Token for johne@test.com that expires in 3 months, use only for testing!!
//const HORRIBLY_HARDCODED_TOKEN = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJqb2huQHRlc3QuY29tIiwiZXhwIjoxNjY1NjA3Njg0fQ.H3G4H3kXF2rbACrwSQBQN-ihj00GoZaH62t7mr7rKSc";

class BookstoreAuth extends ChangeNotifier
{
  bool _signedIn = false;
  bool get signedIn => _signedIn;

  Future<bool> load_token(BuildContext context) async
  {
    // Try to load existing key to skip sign in screen

    Token? token;
    try {
      //String token_str = HORRIBLY_HARDCODED_TOKEN;
      String token_str = (await storage.read(key: TOKEN_STORAGE_KEY))!;
      token = Token(token_type: "Bearer", access_token: token_str);
      print('Existing token found: $token_str');

      await fetch_current_user_and_save_to_app_state(token, context);

      _signedIn = true;
      notifyListeners();

    } catch (e) {
      print('No token found - sign in required');
      _signedIn = false;
    }
    return _signedIn;
  }

  Future<Token?> fetch_current_user_and_save_to_app_state(Token token, BuildContext context) async
  {
    final response = await http.get(
      Uri.parse(SERVER_IP+'/users/me'),
      headers: {
        "Authorization": token.token_type + " " + token.access_token,
      }
    );

    if (response.statusCode == 200) {
      print("Fetched User from API: " + response.body);
      Provider.of<UserModel>(context, listen: false).set(User.fromJson(json.decode(response.body)));
    }
  }

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
      return Token.fromJson(jsonDecode(response.body));
    }
    else
    {
      return null;
    }
  }


  Future<void> signOut() async
  {
    _signedIn = false;
    storage.delete(key: TOKEN_STORAGE_KEY);
    notifyListeners();
  }

  Future<bool> signIn(BuildContext context, String username, String password) async
  {
    Token? result = await get_token(username, password);
    if(  result != null )
      {
        storage.write(key: TOKEN_STORAGE_KEY, value: result.access_token );

        await fetch_current_user_and_save_to_app_state(result, context);

        _signedIn = true;
        notifyListeners();
      }
    else
      {
        _signedIn = false;
        log('error logging in :');
      }

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
