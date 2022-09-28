import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shopy/providers/products_provider.dart';

import 'package:shopy/utils/config.dart';
import 'package:shopy/utils/constants.dart';
import 'package:shopy/widgets/error_dialog.dart';
import 'package:shopy/widgets/my_products/delete_icon_button.dart';
import 'package:shopy/widgets/snackbar.dart';

class MyProductsScreen extends StatelessWidget {
  const MyProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ProductsProvider>(context, listen: false);
    return FutureBuilder(
        future: prov.fetchCurrentUserProducts(),
        builder: ((context, snapshot) {
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
              builder: (context, provider, child) {
                var products = provider.userProducts;
                return RefreshIndicator(
                  onRefresh: () => provider.fetchCurrentUserProducts(),
                  child: ListView.builder(
                    itemCount: provider.userProducts.length,
                    itemBuilder: ((context, index) {
                      var product = products[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: kWhite,
                          backgroundImage: NetworkImage(product.imageUrl),
                        ),
                        title: Text(
                          product.title,
                          style: kTitleStyle.copyWith(fontSize: 16),
                        ),
                        subtitle: Text('${product.price} \$'),
                        trailing: SizedBox(
                          width: deviceWidth(context) * 0.3,
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, kAddProductRoute,
                                      arguments: product);
                                },
                                icon: const Icon(Icons.create, color: kBlack),
                              ),
                              DeleteIconButton(
                                product: product,
                                onPressed: () async {
                                  try {
                                    Navigator.pop(context);
                                    await provider.deleteProduct(product);
                                    customSnakBar(
                                      context,
                                      'Product has been deleted successfully',
                                    );
                                  } catch (error) {
                                    await showDialog<void>(
                                        context: context,
                                        builder: (ctx) {
                                          return ErrorDialog(
                                              error: error.toString());
                                        });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                );
              },
            );
          }
        }));
  }
}
