import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  late String _token;
  late DateTime _expiryDate;
  late String _userId;

  var _headers = {
    HttpHeaders.authorizationHeader:
        'Token 30d2a6f76d8716ad1d77136d29e865ab59470e08',
    HttpHeaders.contentTypeHeader: 'application/json',
  };

  String get tempToken {
    return 'Token 30d2a6f76d8716ad1d77136d29e865ab59470e08';
  }

  // Future<void> _authenticate(var data) async{
  //   final url =
  //       Uri.parse("https://api01.stephenwenceslao.com/api/account/register");
  //   final response = await http.post(
  //     url,
  //     headers: _headers,
  //     body: json.encode(
  //       {
  //         "email": data['email'],
  //         "full_name": "working in progress",
  //         "phone_number": "working in progress",
  //         "password": data['password'],
  //         "password2": data['password']
  //       },
  //     ),
  //   );
  //   inspect(response.body);
  // }

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
      inspect(responseData);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error'].toString());
      }
    } catch (error) {
      throw error;
    }
  }
}
