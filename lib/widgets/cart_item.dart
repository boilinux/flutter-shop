import 'package:app_shop/provider/cart.dart';
import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final data;
  CartItem({required this.data});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 4,
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: ListTile(
          leading: CircleAvatar(
            child: Text('P${data['price']}'),
          ),
          title: Text(data['title']),
          subtitle: Text('Total: P${(data['price'] * data['quantity'])}'),
          trailing: Text('${data['quantity']} x'),
        ),
      ),
    );
  }
}
