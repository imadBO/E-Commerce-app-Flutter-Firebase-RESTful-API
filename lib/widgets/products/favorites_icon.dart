import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopy/providers/products_provider.dart';

class FavoritesIcon extends StatelessWidget {
  const FavoritesIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductsProvider>(context);
    return IconButton(
      padding: const EdgeInsets.only(bottom: 8),
      iconSize: 28,
      tooltip: 'Show only favorites',
      onPressed: () {
        provider.toggleContent();
      },
      icon: Icon(
        provider.onlyFavorites ? Icons.favorite : Icons.favorite_outline,
      ),
    );
  }
}
