import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'package:shopy/models/cart.dart';
import 'package:shopy/models/custom_exception.dart';
import 'package:shopy/models/order.dart';

class OrdersProvider extends ChangeNotifier {
  // ignore: prefer_final_fields
  List<Order> _orders = [];
  final String? token;
  final String? uid;

  OrdersProvider(this.token, this.uid, this._orders);

  List<Order> get orders => [..._orders];
  int get length => _orders.length;

  Future<void> fetchAndSetOrders() async {
    Uri _url = Uri.parse(
        'https://shopy-app-bb0eb-default-rtdb.firebaseio.com/orders/$uid.json?auth=$token');
    try {
      final response = await http.get(_url);
      if (response.statusCode >= 400) {
        throw CustomException(
          message: 'Could not retrieve data, ${response.statusCode}!',
        );
      } else {
        if (json.decode(response.body) != null) {
          final Map<String, dynamic> data = json.decode(response.body);
          List<Order> tempOrders = [];
          data.forEach((id, order) {
            List<Cart> carts = [];
            var products = order['products'];

            for (int i = 0; i < products.length; i++) {
              carts.add(
                Cart(
                  id: products[i]['id'],
                  title: products[i]['title'],
                  quantity: products[i]['quantity'],
                  price: products[i]['price'],
                ),
              );
            }
            tempOrders.add(
              Order(
                id: id,
                amount: order['amount'],
                products: carts,
                dateTime: order['date'],
              ),
            );
          });
          _orders = tempOrders;
        }
      }
    } catch (error) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> addOrder(double amount, products, String shippingAddress) async {
    Uri _url = Uri.parse(
        'https://shopy-app-bb0eb-default-rtdb.firebaseio.com/orders/$uid.json?auth=$token');
    List prodMap = [];
    for (int i = 0; i < products.length; i++) {
      prodMap.add({
        'id': products[i].id,
        'title': products[i].title,
        'price': products[i].price,
        'quantity': products[i].quantity
      });
    }
    String date = DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.now());

    try {
      final response = await http.post(
        _url,
        body: json.encode({
          'amount': amount,
          'products': prodMap,
          'date': date,
          'shippingAddress': shippingAddress,
        }),
      );
      if (response.statusCode >= 400) {
        throw CustomException(
          message: 'Could not add order, ${response.statusCode}!',
        );
      } else {
        _orders.insert(
          0,
          Order(
            id: json.decode(response.body)['name'],
            amount: amount,
            products: products,
            dateTime: date,
          ),
        );
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> clearOrders() async {
    Uri _url = Uri.parse(
        'https://shopy-app-bb0eb-default-rtdb.firebaseio.com/orders/$uid.json?auth=$token');

    try {
      final response = await http.delete(_url);
      if (response.statusCode >= 400) {
        throw const CustomException(
          message: 'Could not clear orders, something went wrong!',
        );
      } else {
        _orders.clear();
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }
}
