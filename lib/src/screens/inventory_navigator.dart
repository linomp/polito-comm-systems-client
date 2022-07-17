// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:bookstore/src/screens/register.dart';
import 'package:bookstore/src/screens/rfid_client.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../auth.dart';
import '../data.dart';
import '../models/registration.dart';
import '../models/shop.dart';
import '../routing.dart';
import '../screens/shop_add_screen.dart';
import '../screens/shop_screen.dart';
import '../screens/sign_in.dart';
import '../widgets/fade_transition_page.dart';
import 'book_details.dart';
import 'inventory_scaffold.dart';

/// Builds the top-level navigator for the app. The pages to display are based
/// on the `routeState` that was parsed by the TemplateRouteParser.
class InventoryNavigator extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const InventoryNavigator({
    required this.navigatorKey,
    super.key,
  });

  @override
  State<InventoryNavigator> createState() => _InventoryNavigatorState();
}

class _InventoryNavigatorState extends State<InventoryNavigator> {
  final _signInKey = const ValueKey('Sign in');
  final _registerKey = const ValueKey('Register');
  final _shopListKey = const ValueKey('Shop List');
  final _scaffoldKey = const ValueKey('App scaffold');
  final _bookDetailsKey = const ValueKey('Book details screen');
  final _shopAddKey = const ValueKey('Shop add screen');
  final _rfidClientKey = const ValueKey('Rfid Client screen');

  @override
  Widget build(BuildContext context) {
    final routeState = RouteStateScope.of(context);
    final authState = BookstoreAuthScope.of(context);
    final pathTemplate = routeState.route.pathTemplate;

    Shop? selectedShop = Provider.of<ShopModel>(context).shop;

    Book? selectedBook;
    if (pathTemplate == '/book/:bookId') {
      selectedBook = libraryInstance.allBooks.firstWhereOrNull(
          (b) => b.id.toString() == routeState.route.parameters['bookId']);
    }

    return Navigator(
      key: widget.navigatorKey,
      onPopPage: (route, dynamic result) {
        // When a page that is stacked on top of the scaffold is popped, display
        // the /books or /authors tab in BookstoreScaffold.
        if (route.settings is Page &&
            (route.settings as Page).key == _bookDetailsKey) {
          routeState.go('/inventory_example');
        }

        return route.didPop(result);
      },
      pages: [
        if (routeState.route.pathTemplate == '/register')
          // Display the register screen.
          MaterialPage<void>(
            key: _registerKey,
            child: RegisterScreen(
              onRegister: (Registration newUserData) async {
                // TODO: display errors if the registration fails.
                try {
                  var signedIn = await authState.register(context,
                      newUserData.mail, newUserData.name, newUserData.password);
                  if (signedIn) {
                    Fluttertoast.showToast(
                        msg: 'Welcome ${newUserData.name}!',
                        toastLength: Toast.LENGTH_LONG,
                        timeInSecForIosWeb: 3,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.red,
                        textColor: Colors.white);
                    await routeState.go('/shoplist');
                  } else {
                    Fluttertoast.showToast(
                        msg: 'Error during registration',
                        toastLength: Toast.LENGTH_LONG,
                        timeInSecForIosWeb: 3,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.red,
                        textColor: Colors.white);
                    await routeState.go('/signin');
                  }
                } catch (e) {
                  print(e);
                  Fluttertoast.showToast(
                      msg: 'Error during registration',
                      toastLength: Toast.LENGTH_LONG,
                      timeInSecForIosWeb: 3,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: Colors.white);
                  await routeState.go('/signin');
                }
              },
            ),
          )
        else if (routeState.route.pathTemplate == '/rfid')
          FadeTransitionPage<void>(
              key: _rfidClientKey, child: RfidClientScreen())
        else if (routeState.route.pathTemplate == '/signin')
          // Display the sign in screen.
          FadeTransitionPage<void>(
            key: _signInKey,
            child: SignInScreen(
              onSignIn: (credentials, {withRFID=false}) async {
                try {
                  var signedIn = await authState.signIn(
                      context, credentials.mail, credentials.password);
                  if (signedIn) {
                    await routeState.go('/shoplist');
                  } else {
                    Fluttertoast.showToast(
                        msg: 'Incorrect login details',
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.red,
                        textColor: Colors.white);
                  }
                } catch (e) {
                  print(e);
                  Fluttertoast.showToast(
                      msg: 'Error signing in',
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: Colors.white);
                }
              },
            ),
          )
        else if ((routeState.route.pathTemplate == '/shoplist') ||
            ((routeState.route.pathTemplate == '/inventory_example') &&
                selectedShop == null))
          // Display the sign in screen.
          FadeTransitionPage<void>(
            key: _shopListKey,
            child: ShopsScreen(),
          )
        else if (routeState.route.pathTemplate == '/shop_add')
          FadeTransitionPage<void>(
            key: _shopAddKey,
            child: addShopsScreen(),
          )
        else ...[
          // Display the app
          FadeTransitionPage<void>(
            key: _scaffoldKey,
            child: const InventoryScaffold(),
          ),
          // Add an additional page to the stack if the user is viewing a book
          // or an author
          if (selectedBook != null)
            MaterialPage<void>(
              key: _bookDetailsKey,
              child: BookDetailsScreen(
                book: selectedBook,
              ),
            )
        ],
      ],
    );
  }
}
