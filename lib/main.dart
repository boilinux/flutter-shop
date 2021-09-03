import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/product_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './provider/products_provider.dart';
import './provider/cart.dart';
import './provider/orders.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './provider/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          create: (ctx) => ProductsProvider('', [], null),
          update: (ctx, auth, previousProducts) => ProductsProvider(
              auth.token.toString(),
              previousProducts!.items,
              {'user_id': auth.userId}),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders('', []),
          update: (ctx, auth, previousOrder) =>
              Orders(auth.token.toString(), previousOrder!.orders),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            // primaryColor: Colors.pink,
            primarySwatch: Colors.blue,
            accentColor: Colors.white,
            buttonColor: Colors.blueAccent,
            // errorColor: Colors.red,
            fontFamily: 'Lato',
          ),
          routes: {
            '/': (ctx) {
              Widget? homepage;
              if (auth.isAuth) {
                homepage = ProductOverviewScreen();
              } else {
                homepage = AuthScreen();
              }

              return homepage;
            },
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
