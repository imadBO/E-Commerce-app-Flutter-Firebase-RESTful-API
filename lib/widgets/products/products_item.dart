import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shopy/providers/cart_provider.dart';

import 'package:shopy/providers/products_provider.dart';
import 'package:shopy/utils/constants.dart';
import 'package:shopy/widgets/error_dialog.dart';
import 'package:shopy/widgets/products/cart_dialog.dart';

class ProductsItem extends StatelessWidget {
  final dynamic product;
  const ProductsItem({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductsProvider>(context);
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          kDetailsScreenRoute,
          arguments: product.id,
        );
      },
      child: Card(
        margin: const EdgeInsets.all(3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: const BorderSide(
            color: kGrey01,
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: GridTile(
            child: Hero(
              tag: product.id,
              child: FadeInImage(
                placeholder: const AssetImage('assets/images/loading.png'),
                image: NetworkImage(product.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            header: Align(
              alignment: const Alignment(-0.90, 0),
              child: Chip(
                backgroundColor: kGreyishPink1,
                // padding: const EdgeInsets.only(left: 8),
                labelPadding: const EdgeInsets.all(2),
                labelStyle: kGeneralTxtStyle.copyWith(color: kRusticRed),
                label: Text('${product.price} \$'),
              ),
            ),
            footer: GridTileBar(
              backgroundColor: kGreyishPink.withOpacity(0.9),
              leading: GestureDetector(
                child: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_outline,
                  color: kRusticRed,
                ),
                onTap: () async {
                  try {
                    await provider.toggleFavorite(product);
                  } catch (error) {
                    await showDialog<void>(
                        context: context,
                        builder: (ctx) {
                          return ErrorDialog(error: error.toString());
                        });
                  }
                },
              ),
              title: Text(
                product.title,
                style: kGeneralTxtStyle.copyWith(color: kRusticRed),
              ),
              trailing: Consumer<CartProvider>(
                builder: (consumerContext, provider, child) {
                  return GestureDetector(
                    child: const Icon(
                      Icons.add_shopping_cart,
                      color: kRusticRed,
                    ),
                    onTap: () {
                      showDialog(
                        context: consumerContext,
                        builder: (context) {
                          return CartDialog(
                            action: 'Add to cart',
                            productData: {
                              'id': product.id,
                              'title': product.title,
                              'price': product.price
                            },
                            undoCallBack: provider.removeItem,
                            addCallBack: provider.addItem,
                            ctx: consumerContext,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
