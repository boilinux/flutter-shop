import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'product.dart';
import '../models/http_exception.dart';
import 'auth.dart';
// import '../models/dummy_products.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];
  final String authToken;
  final data;

  ProductsProvider(this.authToken, this._items, this.data);

  // var _showFavoritesOnly = false;

  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((element) => element.isFavorite).toList();
    // }
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  List<Product> get favoritesItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> fetchAndSetProducts() async {
    var _headers = {
      HttpHeaders.authorizationHeader: authToken,
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    print(authToken);
    final url = Uri.parse("https://api01.stephenwenceslao.com/api/v1/product");
    try {
      final response = await http.get(url, headers: _headers);
      final extractedData = json.decode(response.body) as List;
      final List<Product>? loadedProducts = [];

      // ignore: unnecessary_null_comparison
      if (extractedData == null) {
        return;
      }

      var userId = data['user_id'];
      final url2 = Uri.parse(
          "https://api01.stephenwenceslao.com/api/v1/product/favorites/$userId");
      final response2 = await http.get(url2, headers: _headers);

      final extractedData2 =
          json.decode(response2.body) as Map<String, dynamic>;

      extractedData.forEach((value) {
        bool isfav;
        try {
          isfav = (extractedData2['data'] as List).firstWhere((element) {
            return element['Product'] == value['id'];
          })['isfavorite'] as bool;
        } catch (error) {
          isfav = false;
        }
        loadedProducts!.add(
          Product(
            id: value['id'].toString(),
            title: value['title'],
            description: value['description'],
            price: double.parse(value['price']),
            imageUrl: value['imageUrl'],
            // isFavorite: false
            isFavorite: isfav,
          ),
        );
      });
      _items = loadedProducts!;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    var _headers = {
      HttpHeaders.authorizationHeader: authToken,
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    final url = Uri.parse("https://api01.stephenwenceslao.com/api/v1/product");
    try {
      final response = await http.post(
        url,
        headers: _headers,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
        }),
      );

      final newProduct = Product(
        id: json.decode(response.body)['id'].toString(),
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      inspect(error);
      throw error;
    }
    // _items.insert(0, newProduct); // at the start of the list
  }

  Future<void> updateProduct(String id, Product editProduct) async {
    var _headers = {
      HttpHeaders.authorizationHeader: authToken,
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      final url =
          Uri.parse("https://api01.stephenwenceslao.com/api/v1/product/$id");
      await http.put(
        url,
        headers: _headers,
        body: json.encode({
          'title': editProduct.title,
          'description': editProduct.description,
          'imageUrl': editProduct.imageUrl,
          'price': editProduct.price,
        }),
      );
      _items[prodIndex] = editProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    var _headers = {
      HttpHeaders.authorizationHeader: authToken,
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    final url =
        Uri.parse("https://api01.stephenwenceslao.com/api/v1/product/$id");
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    final existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url, headers: _headers);
    if (response.statusCode > 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
  }
}
