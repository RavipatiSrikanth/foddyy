import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:foddyy/models/products_model.dart';

class ProductNotifier with ChangeNotifier {
  List<Products> _productsList = [];
  Products _currentProduct;

  UnmodifiableListView<Products> get productsList =>
      UnmodifiableListView(_productsList);

  Products get currentProduct => _currentProduct;

  set productsList(List<Products> productsList) {
    _productsList = productsList;
    notifyListeners();
  }

  set currentProduct(Products products) {
    _currentProduct = products;
    notifyListeners();
  }
}
