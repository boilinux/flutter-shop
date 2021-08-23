import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-details-screen';

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as Map;
    final products = Provider.of<ProductsProvider>(
      context,
      listen: false,
    ).findById(data['id']);
    return Scaffold(
      appBar: AppBar(
        title: Text(products.title),
      ),
      // body: GridView.builder(
      //   padding: const EdgeInsets.all(10),
      //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //     crossAxisCount: 2,
      //     childAspectRatio: 3 / 2,
      //     crossAxisSpacing: 10,
      //     mainAxisSpacing: 10,
      //   ),
      //   itemBuilder: (ctx, index) {
      //     return ProductItem(data: {
      //       'id': products[index].id,
      //       'title': products[index].title,
      //       'imageUrl': products[index].imageUrl,
      //     });
      //   },
      //   itemCount: products.length,
      // ),
    );
  }
}
