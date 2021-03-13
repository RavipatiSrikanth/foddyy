import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurant {
  String id, image, name;
  Timestamp craetedAt;

  Restaurant.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    image = data['image'];
    name = data['name'];
    craetedAt = data['craetedAt'];
  }
}
