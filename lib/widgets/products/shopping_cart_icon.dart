import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopy/providers/cart_provider.dart';
import 'package:shopy/utils/constants.dart';

class ShoppingCartIcon extends StatelessWidget {
  const ShoppingCartIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProv = Provider.of<CartProvider>(context, listen: false);
    return FutureBuilder(
      future: cartProv.fetchCart(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Container(
              height: 20,
              width: 20,
              margin: const EdgeInsets.only(bottom: 10, right: 10),
              child: const CircularProgressIndicator(color: kGreyishPink),
            ),
          );
        } else {
          if (snapshot.error != null) {
            return const Icon(Icons.error);
          } else {
            return InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(kCartScreenRoute);
              },
              child: SizedBox(
                height: 40,
                width: 40,
                child: Stack(
                  children: [
                    const Positioned(
                      top: 10,
                      left: 0,
                      child: Icon(Icons.shopping_cart_outlined, size: 28),
                    ),
                    Positioned(
                      top: 5,
                      right: 0,
                      child: Container(
                        height: 20,
                        width: 25,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(2.0),
                        child: FittedBox(
                          child: Consumer<CartProvider>(
                            builder: (context, provider, child) {
                              return Text(
                                '${provider.itemCount}',
                                style: kGeneralTxtStyle.copyWith(
                                  color: kRusticRed,
                                ),
                                overflow: TextOverflow.fade,
                                softWrap: true,
                              );
                            },
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: kGreyishPink,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }
      }),
    );
  }
}
