class Products {
  String pid, pImage, pName, price, rid;

  Products.fromMap(Map<String, dynamic> data) {
    pid = data['id'];
    pImage = data['image'];
    pName = data['name'];
    price = data['price'];
    rid = data['rid'];
  }
}
