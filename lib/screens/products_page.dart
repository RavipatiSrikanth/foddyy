import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:foddyy/models/products_model.dart';
import 'package:foddyy/notifier/products_notifier.dart';
import 'package:foddyy/notifier/restaurant_notifier.dart';
import 'package:foddyy/screens/cart_page.dart';
import 'package:provider/provider.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  Widget productsCard({@required image, @required name, @required price}) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double devicHeight = MediaQuery.of(context).size.height;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Container(
            width: deviceWidth * 0.60,
            height: devicHeight * 0.18,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(
                  image: AssetImage('images/non_veg.jpeg'),
                  height: 20,
                  width: 20,
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'In Rice and Biryani',
                      style: TextStyle(fontSize: 13),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      '₹ $price',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    RatingBar.builder(
                        initialRating: 3,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 15.0,
                        itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                        onRatingUpdate: (rating) {}),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: deviceWidth * 0.45,
                      child: Text(
                        'A delicious savory rice dish that is loaded with spicy marinated mutton',
                        style: TextStyle(fontSize: 13),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Stack(
            children: [
              Positioned(
                child: Container(
                  margin: EdgeInsets.only(bottom: 10),
                  width: deviceWidth * 0.32,
                  height: devicHeight * 0.15,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(image), fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
              Positioned(
                bottom: -5,
                left: 20,
                child: RaisedButton(
                  onPressed: () {
                    setState(() {
                      _isVisible = !_isVisible;
                      isViewCart = !isViewCart;
                    });
                  },
                  color: Colors.red[50],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    side: BorderSide(color: Colors.red),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'ADD',
                        style: TextStyle(color: Colors.red, fontSize: 17),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 30,
                        width: 10,
                        alignment: Alignment.topRight,
                        child: Icon(
                          Icons.add,
                          color: Colors.red,
                          size: 20,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 13,
                child: Visibility(
                  visible: _isVisible,
                  child: Container(
                    height: devicHeight * 0.05,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.red),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              if (_count > 1) {
                                _count--;
                              } else {
                                _isVisible = false;
                                isViewCart = false;
                              }
                            });
                          },
                          color: Colors.white,
                        ),
                        Text(
                          _count.toString(),
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              _count++;
                            });
                          },
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  int _count = 1;
  bool _isVisible = false;
  bool isViewCart = false;

  @override
  void initState() {
    ProductNotifier productNotifier =
        Provider.of<ProductNotifier>(context, listen: false);
    getProducts(productNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RestaurantNotifier restaurantNotifier =
        Provider.of<RestaurantNotifier>(context, listen: false);
    ProductNotifier productNotifier = Provider.of<ProductNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurantNotifier.currentRestaurant.name),
        backgroundColor: Colors.red,
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: productNotifier.productsList.length,
                itemBuilder: (context, index) {
                  return productsCard(
                    image: productNotifier.productsList[index].pImage,
                    name: productNotifier.productsList[index].pName,
                    price: productNotifier.productsList[index].price,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: isViewCart,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => CartPage()));
          },
          child: Container(
            margin: EdgeInsets.all(10),
            height: 65,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('1 ITEM',
                        style: TextStyle(color: Colors.white, fontSize: 14)),
                    Text('₹ 220',
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'View Cart',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  getProducts(ProductNotifier productNotifier) async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Products').get();

    List<Products> _productsList = [];
    snapshot.docs.forEach((element) {
      Products products = Products.fromMap(element.data());
      _productsList.add(products);
    });
    productNotifier.productsList = _productsList;
  }
}
