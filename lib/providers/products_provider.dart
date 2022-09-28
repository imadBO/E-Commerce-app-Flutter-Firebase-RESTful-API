import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import 'package:shopy/models/custom_exception.dart';

import 'package:shopy/models/product.dart';

class ProductsProvider extends ChangeNotifier {
  // ignore: prefer_final_fields
  final String? token;
  final String? uid;
  bool _onlyFavorites = false;
  List<Product> _products = [];
  List<Product> _userProducts = [];

  ProductsProvider(this.token, this.uid, this._products, this._onlyFavorites);

  bool get onlyFavorites => _onlyFavorites;
  int get itemsCount => _products.length;

  List<Product> get userProducts => [..._userProducts];

  List<Product> get products {
    if (_onlyFavorites) {
      return [...fetchFavorites()];
    }
    return [..._products];
  }

  UnmodifiableListView<Product> fetchFavorites() {
    return UnmodifiableListView(
        _products.where((product) => product.isFavorite == true).toList());
  }

  void toggleContent() {
    _onlyFavorites = !_onlyFavorites;
    notifyListeners();
  }

  Future<void> toggleFavorite(Product product) async {
    final Uri _url = Uri.parse(
        'https://shopy-app-bb0eb-default-rtdb.firebaseio.com/userFavorites/$uid/${product.id}.json?auth=$token');
    product.toggleIsFavorite();
    notifyListeners();
    try {
      final response = await http.put(
        _url,
        body: json.encode(product.isFavorite),
      );
      if (response.statusCode >= 400) {
        product.toggleIsFavorite();
        notifyListeners();
        throw const CustomException(
          message: 'Could not change favorites, something went wrong!',
        );
      }
    } catch (error) {
      rethrow;
    }
  }

  Product fetchById(String id) {
    return _products.firstWhere((product) => product.id == id);
  }

  Future<void> fetchCurrentUserProducts() async {
    final Uri _url = Uri.parse(
        'https://shopy-app-bb0eb-default-rtdb.firebaseio.com/products.json?auth=$token&orderBy="creatorId"&equalTo="$uid"');
    try {
      var response = await http.get(_url);
      if (response.statusCode >= 400) {
        throw CustomException(
          message: 'Could not retrieve data, ${response.statusCode}!',
        );
      } else {
        final Map<String, dynamic>? data = json.decode(response.body);
        if (data != null) {
          List<Product> tempProducts = [];
          data.forEach((id, product) {
            tempProducts.insert(
              0,
              Product(
                id: id,
                title: product['title'],
                imageUrl: product['url'],
                description: product['desc'],
                price: double.parse(product['price']),
              ),
            );
          });
          _userProducts = tempProducts;
        }
      }
    } catch (error) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> fetchAndSetProducts() async {
    final Uri _url = Uri.parse(
        'https://shopy-app-bb0eb-default-rtdb.firebaseio.com/products.json?auth=$token');
    final Uri _favUrl = Uri.parse(
        'https://shopy-app-bb0eb-default-rtdb.firebaseio.com/userFavorites/$uid.json?auth=$token');
    try {
      var response = await http.get(_url);
      if (response.statusCode >= 400) {
        throw CustomException(
          message: 'Could not retrieve data, ${response.statusCode}!',
        );
      } else {
        final Map<String, dynamic>? data = json.decode(response.body);
        if (data != null) {
          final favResponse = await http.get(_favUrl);
          if (response.statusCode >= 400) {
            throw CustomException(
              message: 'Could not retrieve data, ${response.statusCode}!',
            );
          } else {
            final Map<String, dynamic>? favData = json.decode(favResponse.body);

            List<Product> tempProducts = [];
            data.forEach((id, product) {
              tempProducts.insert(
                0,
                Product(
                  id: id,
                  title: product['title'],
                  imageUrl: product['url'],
                  description: product['desc'],
                  price: double.parse(product['price']),
                  isFavorite: favData == null ? false : favData[id] ?? false,
                ),
              );
            });
            _products = tempProducts;
          }
        }
      }
    } catch (error) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> addProduct(Map data) async {
    final Uri _url = Uri.parse(
        'https://shopy-app-bb0eb-default-rtdb.firebaseio.com/products.json?auth=$token');
    try {
      data.putIfAbsent('creatorId', () => uid);
      final response = await http.post(_url, body: json.encode(data));
      if (response.statusCode >= 400) {
        throw CustomException(
          message: 'Could not add product, ${response.statusCode}!',
        );
      } else {
        _products.insert(
          0,
          Product(
            id: json.decode(response.body)['name'],
            title: data['title'],
            imageUrl: data['url'],
            description: data['desc'],
            price: double.parse(data['price']),
          ),
        );
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Map data) async {
    int index = _products.indexWhere((prod) => prod.id == id);
    final Uri _url = Uri.parse(
        'https://shopy-app-bb0eb-default-rtdb.firebaseio.com/products/$id.json?auth=$token');

    try {
      final response = await http.patch(_url, body: json.encode(data));
      if (response.statusCode >= 400) {
        throw CustomException(
          message: 'Could not update product, ${response.statusCode}!',
        );
      } else {
        Product newProd = Product(
          id: id,
          title: data['title'],
          imageUrl: data['url'],
          description: data['desc'],
          price: double.parse(data['price']),
          isFavorite: _products[index].isFavorite,
        );
        _products[index] = newProd;
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteProduct(Product product) async {
    var existingProduct = product;
    final index = _products.indexOf(product);
    final Uri _url = Uri.parse(
        'https://shopy-app-bb0eb-default-rtdb.firebaseio.com/products/${product.id}.json?auth=$token');
    try {
      _products.remove(product);
      notifyListeners();
      final response = await http.delete(_url);
      if (response.statusCode >= 400) {
        _products.insert(index, existingProduct);
        notifyListeners();
        throw const CustomException(
          message: 'Could not delete product, something went wrong!',
        );
      }
    } catch (error) {
      rethrow;
    }
  }
}
