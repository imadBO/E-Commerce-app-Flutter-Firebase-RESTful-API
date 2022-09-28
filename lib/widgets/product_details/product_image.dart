import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopy/providers/products_provider.dart';
import 'package:shopy/utils/config.dart';
import 'package:shopy/utils/constants.dart';
import 'package:shopy/widgets/error_dialog.dart';

class ProductImage extends StatelessWidget {
  final String imageUrl, id;
  final double price;
  const ProductImage({
    required this.id,
    required this.imageUrl,
    required this.price,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(height: deviceHeight(context) * 0.5, color: kGreyishPink),
        Container(
          height: deviceHeight(context) * 0.515,
          decoration: const BoxDecoration(
            color: kRusticRed,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(45),
              topRight: Radius.circular(45),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Hero(
            tag: id,
            child: Container(
              height: deviceHeight(context) * 0.50,
              width: deviceWidth(context),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 5,
          bottom: 5,
          child: Container(
            height: 40,
            width: 40,
            decoration: const BoxDecoration(
              color: kRusticRed,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Consumer<ProductsProvider>(
              builder: (context, provider, child) {
                var product = provider.fetchById(id);
                return IconButton(
                  color: kWhite,
                  splashRadius: 2,
                  icon: Icon(
                    product.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_outline,
                  ),
                  onPressed: () async {
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
                );
              },
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: 130,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: kRusticRed,
              border: Border.all(color: kGreyishPink, width: 1),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.payment, color: kWhite),
                const SizedBox(width: 10),
                Text(
                  ' ${price.toStringAsFixed(2)} \$',
                  style: kGeneralTxtStyle.copyWith(
                    fontSize: 18,
                    color: kWhite,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
