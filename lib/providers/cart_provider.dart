import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

import 'package:shopy/models/cart.dart';
import 'package:shopy/models/custom_exception.dart';

class CartProvider extends ChangeNotifier {
  // ignore: prefer_final_fields
  Map<String, Cart> _items = {};
  final String? token;
  final String? uid;

  Map<String, Cart> get items => {..._items};

  CartProvider(this.token, this.uid, this._items);

  int get itemCount => _items.length;

  Future<void> fetchCart() async {
    final Uri _url = Uri.parse(
        'https://shopy-app-bb0eb-default-rtdb.firebaseio.com/cart/$uid.json?auth=$token');
    try {
      final response = await http.get(_url);
      if (response.statusCode >= 400) {
        throw CustomException(
          message: 'Could not retrieve data, ${response.statusCode}!',
        );
      } else {
        if (json.decode(response.body) != null) {
          final Map<String, dynamic> data = json.decode(response.body);
          data.forEach((id, item) {
            String cartId = item.keys.toList()[0];
            _items.putIfAbsent(
              cartId,
              () => Cart(
                id: id,
                title: item[cartId]['title'],
                quantity: item[cartId]['quantity'],
                price: item[cartId]['price'],
              ),
            );
          });
        }
      }
    } catch (error) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> _alterQuantity(String productId, int quantity) async {
    final oldCart = _items[productId];
    final Uri _url = Uri.parse(
        'https://shopy-app-bb0eb-default-rtdb.firebaseio.com/cart/$uid/${oldCart!.id}.json?auth=$token');

    _items.update(
      productId,
      (_) => Cart(
        id: oldCart.id,
        title: oldCart.title,
        quantity: quantity,
        price: oldCart.price,
      ),
    );
    notifyListeners();
    try {
      final response = await http.patch(
        _url,
        body: json.encode({
          productId: {
            'title': oldCart.title,
            'quantity': quantity,
            'price': oldCart.price,
          }
        }),
      );
      if (response.statusCode >= 400) {
        _items.update(
          productId,
          (_) => Cart(
            id: oldCart.id,
            title: oldCart.title,
            quantity: oldCart.quantity,
            price: oldCart.price,
          ),
        );
        notifyListeners();
        throw const CustomException(
          message: 'Could not add product to cart, something went wrong!',
        );
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> _createCart(
      String productId, String title, double price, int quantity) async {
    final Uri _url = Uri.parse(
        'https://shopy-app-bb0eb-default-rtdb.firebaseio.com/cart/$uid.json?auth=$token');
    try {
      final response = await http.post(
        _url,
        body: json.encode({
          productId: {
            'title': title,
            'quantity': quantity,
            'price': price,
          }
        }),
      );
      if (response.statusCode >= 400) {
        throw CustomException(
          message: 'Could not create cart, ${response.statusCode}!',
        );
      } else {
        _items.putIfAbsent(
          productId,
          () => Cart(
            id: json.decode(response.body)['name'],
            title: title,
            quantity: quantity,
            price: price,
          ),
        );
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addItem(
      String productId, String title, double price, int quantity) async {
    price = double.parse(price.toStringAsFixed(2));

    try {
      if (_items.containsKey(productId)) {
        await _alterQuantity(productId, quantity);
      } else {
        await _createCart(productId, title, price, quantity);
      }
    } catch (error) {
      rethrow;
    }
  }

  double get totalAmount {
    double total = 0;
    _items.forEach((key, cart) {
      total += cart.price * cart.quantity;
    });
    return total;
  }

  Future<void> removeItem(String productId) async {
    Cart cart = _items[productId]!;
    final Uri _url = Uri.parse(
        'https://shopy-app-bb0eb-default-rtdb.firebaseio.com/cart/$uid/${cart.id}.json?auth=$token');

    _items.remove(productId);
    notifyListeners();
    try {
      final response = await http.delete(_url);
      if (response.statusCode >= 400) {
        _items.putIfAbsent(productId, () => cart);
        notifyListeners();
        throw CustomException(
          message:
              'Could not delete item from cart, something went wrong! ${response.statusCode}!',
        );
      }
    } catch (error) {
      _items.putIfAbsent(productId, () => cart);
      notifyListeners();
      rethrow;
    }
  }

  Future<void> clear() async {
    final Uri _url = Uri.parse(
        'https://shopy-app-bb0eb-default-rtdb.firebaseio.com/cart/$uid.json?auth=$token');
    try {
      final response = await http.delete(_url);
      if (response.statusCode >= 400) {
        throw CustomException(
          message:
              'Could not clear cart, something went wrong!, ${response.statusCode}!',
        );
      } else {
        _items.clear();
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }
}
