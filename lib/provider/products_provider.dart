import 'package:flutter/foundation.dart';

import 'product.dart';
import '../models/dummy_products.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = dummy_products;

  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  void addProduct() {
    // _items.add();

    notifyListeners();
  }
}
