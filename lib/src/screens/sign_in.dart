// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';
import 'sign_in_screen_totem.dart';

import '../models/credentials.dart';
import 'dart:io' show Platform;
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';


class SignInScreen extends StatefulWidget {
  //
  final ValueChanged<Credentials> onSignIn;

  const SignInScreen({
    required this.onSignIn,
    super.key,
  });

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.linux)
    {
      return Scaffold(
        body: Center(
          child: Card(
            child: Container(
              constraints: BoxConstraints.loose(const Size(600, 600)),
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Sign in', style: Theme
                      .of(context)
                      .textTheme
                      .headline4),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    controller: _emailController,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    controller: _passwordController,
                  ),
                  Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextButton(
                        onPressed: () async {
                          widget.onSignIn(Credentials(
                              _emailController.value.text,
                              _passwordController.value.text));
                        },
                        child: const Text('Sign in'),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(1),
                    child: Link(
                      uri: Uri.parse('/register'),
                      builder: (context, followLink) =>
                          TextButton(
                            onPressed: followLink,
                            child: const Text('Register'),
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
    else if (defaultTargetPlatform == TargetPlatform.windows)
      {
        return Sign_in_totem_screen(onSignIn: widget.onSignIn,);
      }
    else
      {
        return Scaffold(
          body: Center(
            child: Card(
              child: Container(
                constraints: BoxConstraints.loose(const Size(600, 600)),
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Sign in', style: Theme
                        .of(context)
                        .textTheme
                        .headline4),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Email'),
                      controller: _emailController,
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      controller: _passwordController,
                    ),
                    Padding(
                        padding: const EdgeInsets.all(16),
                        child: TextButton(
                          onPressed: () async {
                            widget.onSignIn(Credentials(
                                _emailController.value.text,
                                _passwordController.value.text));
                          },
                          child: const Text('Sign in'),
                        )),


                  ],
                ),
              ),
            ),
          ),
        );
      }

  }
}