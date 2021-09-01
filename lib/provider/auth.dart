import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  // ignore: unused_field
  late DateTime _expiryDate;
  // ignore: unused_field
  late String _userId;

  var _headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
  };

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_token != null) {
      return "Token $_token";
    }

    return null;
  }

  Future<void> signup(var data) async {
    final url =
        Uri.parse("https://api01.stephenwenceslao.com/api/account/register");
    try {
      final response = await http.post(
        url,
        headers: _headers,
        body: json.encode(
          {
            "email": data['email'],
            "full_name": "working in progress",
            "phone_number": "working in progress",
            "password": data['password'],
            "password2": data['password']
          },
        ),
      );

      final responseData = json.decode(response.body);
      inspect(responseData);
      if (responseData['email'] != null) {
        throw HttpException(
            (responseData['email'] as List).toList().toString());
      }

      _token = responseData['token'];
      _userId = responseData['pk'].toString();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> login(var data) async {
    final url =
        Uri.parse("https://api01.stephenwenceslao.com/api/account/login");
    try {
      final response = await http.post(
        url,
        headers: _headers,
        body: json.encode(
          {"email": data['email'], "password": data['password']},
        ),
      );

      final responseData = json.decode(response.body);
      // inspect(responseData);
      // inspect(responseData['user_info']);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error'].toString());
      }
      _token = responseData['token'];
      _userId = responseData['user_info']['id'].toString();
      // inspect(_token);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
