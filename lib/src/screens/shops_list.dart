// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import '../data.dart';
import '../screens/shops.dart';
import '../provider_models/shop.dart';

class ShopsList extends StatelessWidget {
  final List<Shop> albums;
  final ValueChanged<Shop>? onTap;

  const ShopsList({
    required this.albums,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) => ListView.builder(
    itemCount: albums.length,
    itemBuilder: (context, index) => ListTile(
      title: Text(
        albums[index].name,
      ),
      subtitle: Text(

        albums[index].category,
      ),
      onTap: onTap != null ? () => onTap!(albums[index]) : null,
    ),
  );
}
