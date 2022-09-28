import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopy/providers/cart_provider.dart';
import 'package:shopy/utils/constants.dart';
import 'package:shopy/widgets/cart/dialog_button.dart';
import 'package:shopy/widgets/products/cart_dialog.dart';

class CartItem extends StatelessWidget {
  final String cartId, title;
  final String? productId;
  final int quantity;
  final double price;
  final String? image;
  final void Function(DismissDirection)? onDismissed;
  const CartItem({
    required this.cartId,
    this.productId,
    required this.title,
    required this.price,
    required this.quantity,
    this.image,
    this.onDismissed,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: kRusticRed,
        child: const Icon(Icons.delete, size: 30, color: kWhite),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 10),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog<bool>(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: const Text('Are you sure you want to remove this item?'),
                actions: [
                  DialogButton(ctx: ctx, title: 'Yes', returnValue: true),
                  DialogButton(ctx: ctx, title: 'No', returnValue: false),
                ],
              );
            });
      },
      onDismissed: onDismissed,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
        leading: Visibility(
          visible: image != null,
          child: Container(
            constraints:
                const BoxConstraints(minHeight: 50, minWidth: 40, maxWidth: 45),
            decoration: BoxDecoration(
              border: Border.all(color: kGreyishPink, width: 2),
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              image: image != null
                  ? DecorationImage(
                      image: NetworkImage(image!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
          ),
        ),
        title: Text(
          title,
          style: kTitleStyle.copyWith(fontSize: 18, color: kRusticRed),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Price: $price \$',
              style: kGeneralTxtStyle.copyWith(
                color: kGreyishPink,
                fontSize: 12,
              ),
            ),
            Text(
              'Quantity: $quantity',
              style: kGeneralTxtStyle.copyWith(
                color: kGreyishPink,
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: Chip(
          backgroundColor: kGreyishPink,
          label: Text(
            'Total : ${(price * quantity).toStringAsFixed(2)} \$',
          ),
          labelStyle: kGeneralTxtStyle.copyWith(
            color: kRusticRed,
            fontSize: 12,
          ),
        ),
        onTap: () {
          showDialog(
              context: context,
              builder: (ctx) {
                return CartDialog(
                  productData: {
                    'id': productId,
                    'title': title,
                    'price': price,
                    'quantity': quantity
                  },
                  addCallBack: cartProvider.addItem,
                  undoCallBack: cartProvider.removeItem,
                  ctx: context,
                  action: 'Edit',
                );
              });
        },
      ),
    );
  }
}
