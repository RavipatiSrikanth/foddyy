import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:foddyy/models/restaurant_model.dart';

class RestaurantNotifier with ChangeNotifier {
  List<Restaurant> _restaurantList = [];
  Restaurant _currentRestaurant;

  UnmodifiableListView<Restaurant> get restaurantList =>
      UnmodifiableListView(_restaurantList);

  Restaurant get currentRestaurant => _currentRestaurant;

  set restaurantList(List<Restaurant> restaurantList) {
    _restaurantList = restaurantList;
    notifyListeners();
  }

  set currentRestaurant(Restaurant restaurant) {
    _currentRestaurant = restaurant;
    notifyListeners();
  }
}
