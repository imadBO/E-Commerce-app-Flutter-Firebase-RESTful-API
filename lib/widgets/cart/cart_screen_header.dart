import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:shopy/providers/cart_provider.dart';
import 'package:shopy/providers/orders_provider.dart';

import 'package:shopy/utils/config.dart';
import 'package:shopy/utils/constants.dart';
import 'package:shopy/widgets/cart/cart_header_clipper.dart';
import 'package:shopy/widgets/cart/order_dialog.dart';

class CartHeader extends StatelessWidget {
  final double totalAmount;
  final List products;
  const CartHeader({
    required this.totalAmount,
    required this.products,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var ordersProv = Provider.of<OrdersProvider>(context, listen: false);
    var cartProv = Provider.of<CartProvider>(context, listen: false);
    return ClipPath(
      clipper: CartHeaderClipper(),
      child: Container(
        color: kGreyishPink,
        alignment: Alignment.center,
        height: deviceHeight(Scaffold.of(context).context) * 0.15,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        child: Row(
          children: [
            Text(
              'Total : ',
              style: kTitleStyle.copyWith(color: kRusticRed, fontSize: 18),
            ),
            Text(
              '${totalAmount.toStringAsFixed(2)} \$',
              style: kGeneralTxtStyle.copyWith(fontSize: 15, color: kRusticRed),
            ),
            const Spacer(),
            TextButton(
              style: TextButton.styleFrom(
                primary: kRusticRed,
                textStyle: kGeneralTxtStyle,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text('Order Now'),
              onPressed: () {
                showDialog<bool>(
                    context: context,
                    builder: (_) {
                      return OrderDialog(
                        orderCallBack: ordersProv.addOrder,
                        clearCartCallBack: cartProv.clear,
                        amount: totalAmount,
                        products: products,
                      );
                    });
              },
            ),
          ],
        ),
      ),
    );
  }
}
