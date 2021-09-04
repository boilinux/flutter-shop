import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  // ignore: unused_field
  late DateTime _expiryDate;
  // ignore: unused_field
  String? _userId;

  var _headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
  };

  String? get userId {
    if (_userId != null) {
      return _userId;
    }

    return null;
  }

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
        Uri.parse("https://api01.stephenwenceslao.com/api/v1/account/register");
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

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({'token': _token, 'userId': _userId});
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> login(var data) async {
    final url =
        Uri.parse("https://api01.stephenwenceslao.com/api/v1/account/login");
    try {
      final response = await http.post(
        url,
        headers: _headers,
        body: json.encode(
          {"email": data['email'], "password": data['password']},
        ),
      );

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error'].toString());
      }
      _token = responseData['token'];
      _userId = responseData['user_info']['id'].toString();
      // inspect(_token);
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({'token': _token, 'userId': _userId});
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      if (!prefs.containsKey('userData')) {
        return false;
      }

      final extractedUserData =
          json.decode(prefs.getString('userData').toString())
              as Map<String, dynamic>;

      _token = extractedUserData['token'];
      _userId = extractedUserData['userId'];
      notifyListeners();
      return true;
    } catch (error) {
      inspect(error);
      return false;
    }
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
