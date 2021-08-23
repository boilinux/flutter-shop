import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final data;
  ProductItem({required this.data});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: Image.network(
          data['imageUrl'],
          fit: BoxFit.cover,
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          leading: IconButton(
            onPressed: null,
            icon: Icon(
              Icons.favorite,
              color: Theme.of(context).accentColor,
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
            data['title'],
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
