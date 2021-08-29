import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';
import '../provider/products_provider.dart';

class UserProductItem extends StatelessWidget {
  final data;
  UserProductItem({required this.data});

  @override
  Widget build(BuildContext context) {
    final scaffoldmsg = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(data['title']),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(data['imageUrl']),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName,
                    arguments: data['id']);
              },
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              ),
            ),
            IconButton(
              onPressed: () async {
                try {
                  await Provider.of<ProductsProvider>(context, listen: false)
                      .deleteProduct(data['id']);
                } catch (error) {
                  scaffoldmsg.showSnackBar(
                      SnackBar(content: Text('Deleting failed!')));
                }
              },
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
