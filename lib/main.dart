import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shopy/providers/auth_provider.dart';

import 'package:shopy/providers/bottom_nav_bar_provider.dart';
import 'package:shopy/providers/cart_provider.dart';
import 'package:shopy/providers/orders_provider.dart';

import 'package:shopy/providers/products_provider.dart';
import 'package:shopy/screens/add_product_screen.dart';
import 'package:shopy/screens/auth_screen.dart';

import 'package:shopy/screens/cart_screen.dart';
import 'package:shopy/screens/product_details_screen.dart';
import 'package:shopy/screens/home_screen.dart';
import 'package:shopy/screens/products_screen.dart';
import 'package:shopy/utils/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
          create: (context) => ProductsProvider(null, null, [], false),
          update: (context, auth, previousProducts) => ProductsProvider(
            auth.token,
            auth.uid,
            previousProducts == null ? [] : previousProducts.products,
            previousProducts == null ? false : previousProducts.onlyFavorites,
          ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, CartProvider>(
          create: (context) => CartProvider(null, null, {}),
          update: (context, auth, previousCarts) => CartProvider(
            auth.token,
            auth.uid,
            previousCarts == null ? {} : previousCarts.items,
          ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
          create: (context) => OrdersProvider(null, null, []),
          update: (context, auth, previousOrders) => OrdersProvider(
            auth.token,
            auth.uid,
            previousOrders == null ? [] : previousOrders.orders,
          ),
        ),
        ChangeNotifierProvider<NavBarProvider>(
          create: (context) => NavBarProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shopy app',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          appBarTheme: AppBarTheme(
            elevation: 0,
            backgroundColor: kWhite,
            foregroundColor: kBlack,
            titleTextStyle: kTitleStyle.copyWith(color: kRusticRed),
            iconTheme: const IconThemeData(color: kRusticRed),
          ),
          fontFamily: 'Lato',
        ),
        home: const HomeScreen(),
        // initialRoute: kAuthScreenRoute,
        routes: {
          kAuthScreenRoute: (context) => const AuthScreen(),
          kHomeScreenRoute: (context) => const HomeScreen(),
          kDetailsScreenRoute: (context) => const ProductDetailsScreen(),
          kCartScreenRoute: (context) => const CartScreen(),
          kAddProductRoute: (context) => const AddProductScreen(),
          kShopScreenRoute: (context) => const ShopScreen(),
        },
      ),
    );
  }
}
