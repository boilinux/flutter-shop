import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './product_item.dart';
import '../provider/products_provider.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavs;
  ProductGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final products =
        showFavs ? productsData.favoritesItems : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, index) {
        return ChangeNotifierProvider.value(
          value: products[index],
          child: ProductItem(
              // data: {
              //   'id': products[index].id,
              //   'title': products[index].title,
              //   'imageUrl': products[index].imageUrl,
              // },
              ),
        );
      },
      itemCount: products.length,
    );
  }
}
