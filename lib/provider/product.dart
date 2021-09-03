import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './auth.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, var data) async {
    var _headers = {
      HttpHeaders.authorizationHeader: token,
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      var userId = data!['user_id'];
      final url = Uri.parse(
          "https://api01.stephenwenceslao.com/api/v1/product/favorites/$userId");
      final response = await http.put(
        url,
        headers: _headers,
        body: json.encode({
          'Account': userId,
          'Product': data!['product_id'],
          'isfavorite': isFavorite,
        }),
      );
      if (response.statusCode > 400) {
        _setFavValue(oldStatus);
      }
      inspect(data);
      inspect(response);
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
