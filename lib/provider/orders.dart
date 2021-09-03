import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';

import 'cart.dart';
import '../provider/product.dart';
import 'auth.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  String authToken;
  List<OrderItem> _orders = [];

  Orders(this.authToken, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    var _headers = {
      HttpHeaders.authorizationHeader: authToken,
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    final url = Uri.parse("https://api01.stephenwenceslao.com/api/v1/order");
    final response = await http.get(url, headers: _headers);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as List;

    extractedData.forEach((element) {
      loadedOrders.add(OrderItem(
        id: element['id'].toString(),
        amount: double.parse(element['total']),
        dateTime: DateTime.parse(element['datetime']),
        products: (json.decode(element['products']) as List).map((e) {
          return CartItem(
            id: e['id'],
            title: e['title'],
            quantity: int.parse(e['quantity'].toString()),
            price: double.parse(e['price'].toString()),
          );
        }).toList(),
      ));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    var _headers = {
      HttpHeaders.authorizationHeader: authToken,
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    final url = Uri.parse("https://api01.stephenwenceslao.com/api/order");
    final timestamp = DateTime.now();
    try {
      final response = await http.post(
        url,
        headers: _headers,
        body: json.encode({
          'total': total,
          'datetime': DateTime.now().toIso8601String(),
          'products': json.encode(cartProducts.map((cp) {
            return {
              'id': cp.id,
              'title': cp.title,
              'quantity': cp.quantity,
              'price': cp.price,
            };
          }).toList()),
        }),
      );
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['data']['id'].toString(),
          amount: total,
          products: cartProducts,
          dateTime: timestamp,
        ),
      );
      notifyListeners();
    } catch (error) {
      inspect(error);
      throw error;
    }

    notifyListeners();
  }
}
