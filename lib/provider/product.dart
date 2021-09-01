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

  var _headers = {
    HttpHeaders.authorizationHeader: '',
    HttpHeaders.contentTypeHeader: 'application/json',
  };

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus() async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final url =
          Uri.parse("https://api01.stephenwenceslao.com/api/product/$id");
      final response = await http.put(
        url,
        headers: _headers,
        body: json.encode({
          'isfavorite': isFavorite,
        }),
      );
      if (response.statusCode > 400) {
        _setFavValue(oldStatus);
      }
      inspect(response);
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
