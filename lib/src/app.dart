// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

import 'routing.dart';
import 'screens/inventory_navigator.dart';
import 'services/auth.dart';

const String DEBUG = String.fromEnvironment('DEBUG', defaultValue: 'FALSE');
const SERVER_IP =
    (DEBUG == "TRUE") ? 'http://localhost:8000' : 'http://apps.xmp.systems:80';

const TOKEN_STORAGE_KEY = 'jwt';
// final storage = FlutterSecureStorage();
final LocalStorage storage = new LocalStorage('inventory_app');

// wigdet class for the bookstore
class Bookstore extends StatefulWidget {
  const Bookstore({super.key});

  @override
  State<Bookstore> createState() => _BookstoreState();
}

// wigdet class for the bookstore
class _BookstoreState extends State<Bookstore> {
  final _auth = BookstoreAuth();
  final _navigatorKey = GlobalKey<NavigatorState>();
  late final RouteState _routeState;
  late final SimpleRouterDelegate _routerDelegate;
  late final TemplateRouteParser _routeParser;

  @override
  void initState() {
    /// Configure the parser with all of the app's allowed path templates.
    _routeParser = TemplateRouteParser(
      allowedPaths: [
        '/register',
        '/rfid',
        '/setup-rfid',
        '/setup-rfid2',
        '/setup-rfid3',
        '/inventory_example',
        '/signin',
        '/shop_add',
        '/shoplist',
        '/authors',
        '/settings',
        '/books/new',
        '/books/all',
        '/books/popular',
        '/book/:bookId',
        '/author/:authorId',
        '/items/create',
        '/items/rent',
        '/items/return'
      ],
      //
      guard: _guard,
      initialRoute: '/signin',
    );

    _routeState = RouteState(_routeParser);

    _routerDelegate = SimpleRouterDelegate(
      routeState: _routeState,
      navigatorKey: _navigatorKey,
      builder: (context) => InventoryNavigator(
        navigatorKey: _navigatorKey,
      ),
    );

    // Listen for when the user logs out and display the signin screen.
    _auth.addListener(_handleAuthStateChanged);

    super.initState();
  }

  @override
  Widget build(BuildContext context) => RouteStateScope(
        notifier: _routeState,
        child: BookstoreAuthScope(
          notifier: _auth,
          child: MaterialApp.router(
            routerDelegate: _routerDelegate,
            routeInformationParser: _routeParser,
            // Revert back to pre-Flutter-2.5 transition behavior:
            // https://github.com/flutter/flutter/issues/82053
            theme: ThemeData(
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
                  TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
                },
              ),
            ),
          ),
        ),
      );

  Future<ParsedRoute> _guard(ParsedRoute from) async {
    final signedIn = _auth.signedIn ? true : await _auth.load_token(context);
    final signInRoute = ParsedRoute('/signin', '/signin', {}, {});
    final registerRoute = ParsedRoute('/register', '/register', {}, {});
    final rfidSetupRoute = ParsedRoute('/setup-rfid', '/setup-rfid', {}, {});
    final rfidSetupRoute2 = ParsedRoute('/setup-rfid2', '/setup-rfid2', {}, {});
    final rfidSetupRoute3 = ParsedRoute('/setup-rfid3', '/setup-rfid3', {}, {});

    // Go to /signin if the user is not signed, but allow register
    if (!signedIn &&
        (from != signInRoute) &&
        (from != registerRoute) &&
        (from != rfidSetupRoute) &&
        (from != rfidSetupRoute2) &&
        (from != rfidSetupRoute3)) {
      return signInRoute;
    }
    // Go to /shoplist if the user is signed in and tries to go to /signin.
    else if (signedIn && from == signInRoute) {
      return ParsedRoute('/shoplist', '/shoplist', {}, {});
    }
    return from;
  }

  void _handleAuthStateChanged() {
    if (!_auth.signedIn) {
      _routeState.go('/signin');
    }
  }

  @override
  //release resources
  void dispose() {
    _auth.removeListener(_handleAuthStateChanged);
    _routeState.dispose();
    _routerDelegate.dispose();
    super.dispose();
  }
}
