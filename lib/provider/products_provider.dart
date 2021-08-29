import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'product.dart';
import '../models/http_exception.dart';
// import '../models/dummy_products.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];

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
  var _headers = {
    HttpHeaders.authorizationHeader:
        "Token c35816acb66f512cfe88b667edcd40c3e8be7a30",
    HttpHeaders.contentTypeHeader: 'application/json',
  };

  Future<void> fetchAndSetProducts() async {
    final url = Uri.parse("https://api01.stephenwenceslao.com/api/product");
    try {
      final response = await http.get(url, headers: _headers);
      final extractedData = json.decode(response.body) as List;
      final List<Product> loadedProducts = [];

      extractedData.forEach((value) {
        loadedProducts.add(Product(
          id: value['id'].toString(),
          title: value['title'],
          description: value['description'],
          price: double.parse(value['price']),
          imageUrl: value['imageUrl'],
          isFavorite: value['isfavorite'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse("https://api01.stephenwenceslao.com/api/product");
    try {
      final response = await http.post(
        url,
        headers: _headers,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
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
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      final url =
          Uri.parse("https://api01.stephenwenceslao.com/api/product/$id");
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
    final url =
        Uri.parse("https://api01.stephenwenceslao.com/api/product/1$id");
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
