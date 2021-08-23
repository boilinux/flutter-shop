import 'package:flutter/material.dart';

import '../models/product.dart';
import '../models/dummy_products.dart';
import '../widgets/product_item.dart';

class ProductOverviewScreen extends StatelessWidget {
  final List<Product> products = dummy_products;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (ctx, index) {
          return ProductItem(data: {
            'id': products[index].id,
            'title': products[index].title,
            'imageUrl': products[index].imageUrl,
          });
        },
        itemCount: products.length,
      ),
    );
  }
}
