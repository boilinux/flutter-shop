import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../provider/product.dart';

class ProductItem extends StatelessWidget {
  // final data;
  // ProductItem({required this.data});

  @override
  Widget build(BuildContext context) {
    final _product = Provider.of<Product>(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(ProductDetailScreen.routeName, arguments: {
              'id': _product.id,
            });
          },
          child: Image.network(
            _product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          leading: IconButton(
            onPressed: () => _product.toggleFavoriteStatus(),
            icon: Icon(
              _product.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _product.isFavorite
                  ? Colors.red
                  : Theme.of(context).accentColor,
            ),
          ),
          trailing: IconButton(
            onPressed: null,
            icon: Icon(
              Icons.shopping_bag,
              color: Theme.of(context).accentColor,
            ),
          ),
          title: Text(
            _product.title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
