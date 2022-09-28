import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'package:shopy/screens/account_screen.dart';
import 'package:shopy/screens/my_products_screen.dart';
import 'package:shopy/screens/orders_screen.dart';
import 'package:shopy/screens/products_screen.dart';

class NavBarProvider extends ChangeNotifier {
  // ignore: prefer_final_fields
  List<Map> _pages = [
    {'title': 'Products', 'page': const ShopScreen()},
    {'title': 'Orders', 'page': const OrdersScreen()},
    {'title': 'My Products', 'page': const MyProductsScreen()},
    {'title': 'Account', 'page': const AccountScreen()},
  ];
  // ignore: unused_field
  int _index = 0;

  int get index => _index;
  UnmodifiableListView<Map> get pages => UnmodifiableListView(_pages);
  void updateIndex(int newIndex) {
    _index = newIndex;
    notifyListeners();
  }

  void resetIndex() {
    _index = 0;
  }
}
