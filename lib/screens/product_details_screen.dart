import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shopy/providers/cart_provider.dart';

import 'package:shopy/providers/products_provider.dart';
import 'package:shopy/utils/constants.dart';
import 'package:shopy/widgets/product_details/product_image.dart';
import 'package:shopy/widgets/product_details/text_section.dart';
import 'package:shopy/widgets/products/cart_dialog.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as String;
    final product =
        Provider.of<ProductsProvider>(context, listen: false).fetchById(id);
    final cartProv = Provider.of<CartProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kGreyishPink,
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductImage(
              id: id,
              imageUrl: product.imageUrl,
              price: product.price,
            ),
            TextSection(title: 'Description : ', content: product.description),
          ],
        ),
      ),
      floatingActionButton: Align(
        alignment: const Alignment(1.1, 1.05),
        child: FloatingActionButton(
          backgroundColor: kRusticRed,
          mini: true,
          child: const Icon(
            Icons.add_shopping_cart,
            color: kWhite,
            size: 20,
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return CartDialog(
                    action: 'Add to cart',
                    productData: {
                      'id': product.id,
                      'title': product.title,
                      'price': product.price
                    },
                    addCallBack: cartProv.addItem,
                    undoCallBack: cartProv.removeItem,
                    ctx: context,
                  );
                });
          },
        ),
      ),
    );
  }
}
