import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopy/providers/orders_provider.dart';
import 'package:shopy/utils/constants.dart';
import 'package:shopy/widgets/orders/order_item.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<OrdersProvider>(context, listen: false);
    return FutureBuilder(
      future: prov.fetchAndSetOrders(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: kGreyishPink),
          );
        } else {
          if (snapshot.error != null) {
            return const Center(
              child: Text('Could not fetch orders, something went wrong'),
            );
          } else {
            return Consumer<OrdersProvider>(
              builder: (context, provider, child) {
                return provider.length == 0
                    ? const Center(
                        child: Text('No orders yet!'),
                      )
                    : ListView.builder(
                        itemCount: provider.length,
                        itemBuilder: (context, index) {
                          var order = provider.orders[index];
                          return OrderItem(
                            amount: order.amount,
                            date: order.dateTime,
                            products: order.products,
                          );
                        },
                      );
              },
            );
          }
        }
      }),
    );
  }
}
