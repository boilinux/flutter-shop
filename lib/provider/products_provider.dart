import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'product.dart';
import '../models/dummy_products.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = dummy_products;

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

  Future<void> addProduct(Product product) {
    final url = Uri.parse("https://api01.stephenwenceslao.com/api/product");
    return http
        .post(
      url,
      headers: {
        HttpHeaders.authorizationHeader:
            "Token c35816acb66f512cfe88b667edcd40c3e8be7a30",
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: json.encode({
        'title': product.title,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'isFavorite': product.isFavorite,
      }),
    )
        .then((value) {
      final newProduct = Product(
        id: json.decode(value.body)['id'].toString(),
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    }).catchError((onError) {
      inspect(onError);
      throw onError;
    });
    // _items.insert(0, newProduct); // at the start of the list
  }

  void updateProduct(String id, Product editProduct) {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      _items[prodIndex] = editProduct;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
