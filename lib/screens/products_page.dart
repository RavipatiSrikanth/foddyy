import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foddyy/models/products_model.dart';
import 'package:foddyy/notifier/products_notifier.dart';
import 'package:foddyy/notifier/restaurant_notifier.dart';
import 'package:foddyy/screens/cart_page.dart';
import 'package:foddyy/widgets/products_card_widget.dart';
import 'package:provider/provider.dart';

class ProductsPage extends StatefulWidget {
  final String rID;

  const ProductsPage({Key key, this.rID}) : super(key: key);
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  bool isViewCart = false;
  int totalItems = 0;
  int totalAmount = 0;

  @override
  void initState() {
    super.initState();
    ProductNotifier productNotifier =
        Provider.of<ProductNotifier>(context, listen: false);
    getProducts(productNotifier);
  }

  addToTotalItems() {
    setState(() {
      totalItems++;
    });
  }

  deleteTotalItems() {
    if (totalItems > 0) {
      setState(() {
        totalItems--;
      });
    } else {
      setState(() {
        isViewCart = false;
      });
    }
  }

  setViewCart() {
    print('total items: ' + totalItems.toString());
    if (totalItems > 0) {
      setState(() {
        isViewCart = true;
      });
    } else {
      setState(() {
        isViewCart = false;
      });
    }
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
                  return ProductsCard(
                    setViewCart: setViewCart,
                    addToTotalItems: addToTotalItems,
                    deleteTotalItems: deleteTotalItems,
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
                    Text(totalItems.toString() + ' ITEM',
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
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Products')
        .where('rid', isEqualTo: widget.rID)
        .get();

    List<Products> _productsList = [];
    snapshot.docs.forEach((element) {
      Products products = Products.fromMap(element.data());
      _productsList.add(products);
    });
    productNotifier.productsList = _productsList;
  }
}
