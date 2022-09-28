import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopy/providers/products_provider.dart';
import 'package:shopy/utils/constants.dart';
import 'package:shopy/widgets/products/products_item.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prodProv = Provider.of<ProductsProvider>(context, listen: false);
    return FutureBuilder(
        future: prodProv.fetchAndSetProducts(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: kGreyishPink),
            );
          }
          if (snapshot.error != null) {
            return const Center(
              child: Text('Could not fetch products, something went wrong'),
            );
          } else {
            return Consumer<ProductsProvider>(
              builder: (context, productsProv, child) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.5),
                  child: productsProv.products.isEmpty
                      ? Center(
                          child: productsProv.onlyFavorites
                              ? const Text('You didn\'t like any products yet!')
                              : const Text('No items yet!'),
                        )
                      : GridView.builder(
                          itemCount: productsProv.products.length,
                          itemBuilder: (context, index) {
                            var product = productsProv.products[index];
                            return ProductsItem(product: product);
                          },
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 3.6 / 4,
                          ),
                        ),
                );
              },
            );
          }
        });
  }
}
