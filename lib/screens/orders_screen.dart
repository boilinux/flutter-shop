import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/orders.dart';
import '../widgets/order_item.dart' as ord;
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    print('ayay');
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
          builder: (ctx, data) {
            if (data.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (data.error != null) {
                // Do error handling here!
                return Center(
                  child: Text('An error occurred!'),
                );
              } else {
                return Consumer<Orders>(
                  builder: (ctx, orderData, _) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        await Provider.of<Orders>(context, listen: false)
                            .fetchAndSetOrders();
                      },
                      child: ListView.builder(
                          itemBuilder: (ctx, i) {
                            return ord.OrderItem(orderData.orders[i]);
                          },
                          itemCount: orderData.orders.length),
                    );
                  },
                );
              }
            }
          },
        ));
  }
}
