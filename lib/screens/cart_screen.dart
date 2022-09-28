import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:shopy/providers/cart_provider.dart';
import 'package:shopy/providers/products_provider.dart';
import 'package:shopy/utils/config.dart';
import 'package:shopy/utils/constants.dart';

import 'package:shopy/widgets/cart/cart_item.dart';
import 'package:shopy/widgets/cart/cart_screen_header.dart';
import 'package:shopy/widgets/error_dialog.dart';
import 'package:shopy/widgets/snackbar.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = deviceHeight(context);
    final productsProv = Provider.of<ProductsProvider>(context, listen: false);
    return Consumer<CartProvider>(
      builder: (consumerContext, provider, child) {
        var items = provider.items.values.toList();
        var keys = provider.items.keys.toList();
        var amount = provider.totalAmount;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: items.isEmpty ? kWhite : kGreyishPink,
            title: const Text('Cart', style: TextStyle(color: kRusticRed)),
            iconTheme: const IconThemeData(color: kRusticRed),
          ),
          body: items.isEmpty
              ? Container(
                  alignment: Alignment.center,
                  child: const Text(
                      'No items yet! go find it, love it, buy it.',
                      style: kGeneralTxtStyle),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      CartHeader(totalAmount: amount, products: items),
                      SizedBox(
                        height: height * 0.85,
                        child: ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            var cartItem = items[index];
                            var productId = keys[index];
                            return CartItem(
                              cartId: cartItem.id,
                              productId: productId,
                              title: cartItem.title,
                              price: cartItem.price,
                              quantity: cartItem.quantity,
                              image: productsProv.fetchById(productId).imageUrl,
                              onDismissed: (_) async {
                                try {
                                  await provider.removeItem(productId);
                                  customSnakBar(
                                    consumerContext,
                                    'the item has been deleted successfully',
                                  );
                                } catch (error) {
                                  showDialog(
                                    context: consumerContext,
                                    builder: (context) {
                                      return ErrorDialog(
                                        error: error.toString(),
                                      );
                                    },
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
