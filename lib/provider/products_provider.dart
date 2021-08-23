import 'package:flutter/foundation.dart';

import '../models/product.dart';
import '../models/dummy_products.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = dummy_products;

  List<Product> get items {
    return [..._items];
  }

  void addProduct() {
    // _items.add();

    notifyListeners();
  }
}
