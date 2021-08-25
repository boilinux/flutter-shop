import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app_shop/provider/cart.dart';

class CartItem extends StatelessWidget {
  final data;
  CartItem({required this.data});
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(data['id']),
      background: Container(
        alignment: Alignment.centerRight,
        color: Theme.of(context).primaryColor,
        child: Icon(
          Icons.delete,
          size: 40,
          color: Colors.white,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(data['productId']);
      },
      direction: DismissDirection.endToStart,
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(child: Text('P${data['price']}')),
              ),
            ),
            title: Text(data['title']),
            subtitle: Text('Total: P${(data['price'] * data['quantity'])}'),
            trailing: Text('${data['quantity']} x'),
          ),
        ),
      ),
    );
  }
}
