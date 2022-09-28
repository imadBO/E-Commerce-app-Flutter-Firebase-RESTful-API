import 'package:flutter/material.dart';
import 'package:shopy/utils/constants.dart';
import 'package:shopy/widgets/cart/cart_item.dart';

class OrderItem extends StatefulWidget {
  final double amount;
  final String date;
  final List products;
  const OrderItem({
    required this.amount,
    required this.date,
    required this.products,
    Key? key,
  }) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool visible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            'Amount : ${widget.amount.toStringAsFixed(2)} \$',
            style: kTitleStyle.copyWith(fontSize: 18, color: kRusticRed),
          ),
          subtitle: Text(
            widget.date,
            style: kGeneralTxtStyle.copyWith(color: kGreyishPink),
          ),
          trailing: Icon(visible ? Icons.expand_less : Icons.expand_more),
          onTap: () {
            setState(() {
              visible = !visible;
            });
          },
        ),
        Visibility(
          visible: visible,
          child: Column(
            children: widget.products.map((product) {
              return CartItem(
                cartId: product.id,
                title: product.title,
                price: product.price,
                quantity: product.quantity,
              );
            }).toList(),
          ),
        ),
        const Divider(color: kGrey02, indent: 10, endIndent: 10, height: 2),
      ],
    );
  }
}
