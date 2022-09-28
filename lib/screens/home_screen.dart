import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shopy/providers/auth_provider.dart';

import 'package:shopy/providers/bottom_nav_bar_provider.dart';
import 'package:shopy/screens/auth_screen.dart';
import 'package:shopy/widgets/my_products/add_product_icon.dart';

import 'package:shopy/widgets/navigation_bar.dart';
import 'package:shopy/widgets/orders/clear_orders_icon.dart';
import 'package:shopy/widgets/products/favorites_icon.dart';
import 'package:shopy/widgets/products/shopping_cart_icon.dart';
import 'package:shopy/widgets/splash_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);
    return !provider.isAuth
        ? FutureBuilder(
            future: provider.tryAutoLogin(),
            builder: ((context, snapshot) {
              return snapshot.connectionState == ConnectionState.waiting
                  ? const SplashScreen()
                  : const AuthScreen();
            }),
          )
        : Consumer<NavBarProvider>(
            builder: (context, provider, child) {
              return Scaffold(
                appBar: AppBar(
                  title: Text('${provider.pages[provider.index]['title']}'),
                  actions: [
                    Visibility(
                      visible: provider.index == 0,
                      child: const ShoppingCartIcon(),
                    ),
                    Visibility(
                      visible: provider.index == 0,
                      child: const FavoritesIcon(),
                    ),
                    Visibility(
                      visible: provider.index == 1,
                      child: const ClearOrdersIcon(),
                    ),
                    Visibility(
                      visible: provider.index == 2,
                      child: const AddProductIcon(),
                    ),
                  ],
                ),
                body: provider.pages[provider.index]['page'],
                bottomNavigationBar: CustomNavigationBar(
                  index: provider.index,
                  onUpdate: provider.updateIndex,
                ),
              );
            },
          );
  }
}
