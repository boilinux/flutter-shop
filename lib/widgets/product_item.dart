import 'package:app_shop/provider/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../provider/product.dart';
import '../provider/cart.dart';

class ProductItem extends StatelessWidget {
  // final data;
  // ProductItem({required this.data});

  @override
  Widget build(BuildContext context) {
    final _product = Provider.of<Product>(
      context,
      listen: false,
    );
    final _cart = Provider.of<Cart>(
      context,
      listen: false,
    );

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
          leading: ConsumerProductFavorite(product: _product),
          trailing: IconButton(
            onPressed: () {
              _cart.addItem(_product.id, _product.price, _product.title);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Added item to cart.',
                    textAlign: TextAlign.center,
                  ),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      _cart.removeSingleItem(_product.id);
                    },
                  ),
                ),
              );
            },
            icon: Icon(
              Icons.shopping_cart,
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

class ConsumerProductFavorite extends StatelessWidget {
  const ConsumerProductFavorite({
    Key? key,
    required Product product,
  })  : _product = product,
        super(key: key);

  final Product _product;

  @override
  Widget build(BuildContext context) {
    return Consumer<Product>(
      builder: (ctx, product, child) => IconButton(
        onPressed: () => _product.toggleFavoriteStatus(),
        icon: Icon(
          _product.isFavorite ? Icons.favorite : Icons.favorite_border,
          color:
              _product.isFavorite ? Colors.red : Theme.of(context).accentColor,
        ),
      ),
    );
  }
}
