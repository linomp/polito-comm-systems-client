// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:bookstore/src/screens/inventory_screen_example.dart';
import 'package:bookstore/src/screens/rent_items.dart';
import 'package:bookstore/src/screens/return_items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/shop.dart';
import '../routing.dart';
import '../screens/settings.dart';
import '../widgets/fade_transition_page.dart';

class InventoryScaffoldBody extends StatelessWidget {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  const InventoryScaffoldBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var currentRoute = RouteStateScope.of(context).route;

    return Navigator(
      key: navigatorKey,
      onPopPage: (route, dynamic result) => route.didPop(result),
      pages: [
        if (currentRoute.pathTemplate.startsWith('/settings'))
          const FadeTransitionPage<void>(
            key: ValueKey('settings'),
            child: SettingsScreen(),
          )
        else if (currentRoute.pathTemplate.startsWith('/inventory_example'))
          FadeTransitionPage<void>(
            key: ValueKey('inventory_example'),
            child: Consumer<ShopModel>(
              builder: (context, shop, child) => InventoryScreen(
                shopModel: shop,
              ),
            ),
          )
        else if (currentRoute.pathTemplate.startsWith('/items/rent'))
          FadeTransitionPage<void>(
            key: ValueKey('rent'),
            child: Consumer<ShopModel>(
              builder: (context, shop, child) => RentItemsScreen(
                shopModel: shop,
              ),
            ),
          )
        else if (currentRoute.pathTemplate.startsWith('/items/return'))
          FadeTransitionPage<void>(
            key: ValueKey('return'),
            child: Consumer<ShopModel>(
              builder: (context, shop, child) => ReturnItemsScreen(
                shopModel: shop,
              ),
            ),
          )
        else
          FadeTransitionPage<void>(
            key: const ValueKey('empty'),
            child: Container(),
          ),
      ],
    );
  }
}
