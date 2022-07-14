// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:adaptive_navigation/adaptive_navigation.dart';
import 'package:bookstore/src/screens/inventory_scaffold_body.dart';
import 'package:flutter/material.dart';

import '../routing.dart';

class InventoryScaffold extends StatelessWidget {
  const InventoryScaffold({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final routeState = RouteStateScope.of(context);
    final selectedIndex = _getSelectedIndex(routeState.route.pathTemplate);

    return Scaffold(
      body: AdaptiveNavigationScaffold(
        selectedIndex: selectedIndex,
        body: const InventoryScaffoldBody(),
        onDestinationSelected: (idx) {
          if (idx == 0) routeState.go('/shoplist');
          if (idx == 1) routeState.go('/inventory_example');
          if (idx == 2) routeState.go('/settings');
        },
        destinations: const [
          AdaptiveScaffoldDestination(
            title: 'Shops',
            icon: Icons.store,
          ),
          AdaptiveScaffoldDestination(
            title: 'Items',
            icon: Icons.dataset,
          ),
          AdaptiveScaffoldDestination(
            title: 'Settings',
            icon: Icons.settings,
          ),
        ],
      ),
    );
  }

  int _getSelectedIndex(String pathTemplate) {
    if (pathTemplate.startsWith('/shoplist')) return 0;
    if (pathTemplate.startsWith('/inventory_example')) return 1;
    if (pathTemplate == '/settings') return 2;
    return 0;
  }
}
