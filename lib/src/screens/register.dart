// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

import '../models/registration.dart';

class RegisterScreen extends StatefulWidget {
  final ValueChanged<Registration> onRegister;

  const RegisterScreen({
    required this.onRegister,
    super.key,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _mailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Card(
            child: Container(
              constraints: BoxConstraints.loose(const Size(600, 600)),
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Register',
                      style: Theme.of(context).textTheme.headline4),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Name'),
                    controller: _nameController,
                  ),
                  // TODO: validate format!
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    controller: _mailController,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    controller: _passwordController,
                  ),
                  // TODO: validate they coincide!
                  TextField(
                    decoration:
                        const InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    controller: _passwordConfirmController,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextButton(
                      onPressed: () async {
                        var nameOk = _nameController.text.isNotEmpty;
                        var emailOk = _mailController.text.isNotEmpty &&
                            _mailController.text.contains('@') &&
                            _mailController.text.contains('.');
                        var passwordsOk = _passwordController.text.isNotEmpty &&
                            (_passwordController.text ==
                                _passwordConfirmController.text);
                        if (nameOk && emailOk && passwordsOk) {
                          widget.onRegister(Registration(
                            _nameController.value.text,
                            _mailController.value.text,
                            _passwordController.value.text,
                          ));
                        } else if (!nameOk) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Please provide a name'),
                          ));
                        } else if (!emailOk) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Invalid email address'),
                          ));
                        } else if (!passwordsOk) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Passwords do not match'),
                          ));
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(1),
                    child: Link(
                      uri: Uri.parse('/signin'),
                      builder: (context, followLink) => TextButton(
                        onPressed: followLink,
                        child: const Text('Back to Sign In'),
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
