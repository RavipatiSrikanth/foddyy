class Products {
  String pImage, pName, rid;
  String pid;
  int price;
  int qty;

  Products.fromMap(Map<String, dynamic> data) {
    pid = data['id'];
    pImage = data['image'];
    pName = data['name'];
    price = data['price'];
    rid = data['rid'];
    qty = data['qty'];
  }
}
