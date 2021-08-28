import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../provider/products_provider.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import './edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () async {
              // final res;
              // final url =
              //     Uri.parse("https://api01.stephenwenceslao.com/api/product");
              // final response = await http.post(
              //   url,
              //   headers: {
              //     HttpHeaders.authorizationHeader:
              //         "Token aa44c3a429a1b582814c209590c5f50368b80cca",
              //     HttpHeaders.contentTypeHeader: 'application/json',
              //   },
              //   body: json.encode({
              //     "title": "title123",
              //     "description": "description123",
              //     "imageUrl": "123123",
              //     "price": 123,
              //     "isFavorite": 1
              //   }),
              // );
              // if (response.statusCode == 201) {
              //   // If the server did return a 201 CREATED response,
              //   // then parse the JSON.
              //   res = jsonDecode(response.body).toString();
              // } else {
              //   // If the server did not return a 201 CREATED response,
              //   // then throw an exception.
              //   res = 'Failed. ' + response.statusCode.toString();
              // }
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(
              //     content: Text(
              //       res,
              //       textAlign: TextAlign.center,
              //     ),
              //   ),
              // );
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemBuilder: (ctx, index) {
            return Column(children: [
              UserProductItem(data: {
                'id': productsData.items[index].id,
                'title': productsData.items[index].title,
                'imageUrl': productsData.items[index].imageUrl,
              }),
              Divider(),
            ]);
          },
          itemCount: productsData.items.length,
        ),
      ),
    );
  }
}
