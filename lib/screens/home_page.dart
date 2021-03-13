import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:foddyy/models/restaurant_model.dart';
import 'package:foddyy/notifier/restaurant_notifier.dart';
import 'package:foddyy/screens/products_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> _carouseImagelList = [];

  Widget sliderImage({@required String image}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        image: DecorationImage(image: NetworkImage(image), fit: BoxFit.cover),
      ),
    );
  }

  Widget restaurantCard({@required String name, @required String image}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 10,
      child: Column(
        children: [
          Container(
            width: 400,
            height: 180,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(image),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
          ),
          Container(
            width: 400,
            height: 80,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      name,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: 1,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.red,
                        ),
                        Text(
                          '4.0',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '/5',
                          style: TextStyle(fontSize: 17),
                        )
                      ],
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Andhra, Biryani, North Indian'),
                    SizedBox(
                      width: 2,
                    ),
                    Text('₹250 for one'),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _count = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();
  @override
  void initState() {
    RestaurantNotifier restaurantNotifier =
        Provider.of<RestaurantNotifier>(context, listen: false);
    getRestaurants(restaurantNotifier);
    getImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RestaurantNotifier restaurantNotifier =
        Provider.of<RestaurantNotifier>(context);
    return Scaffold(
      //backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('L.B.Nagar'),
        elevation: 0.0,
        leading: Icon(
          Icons.my_location,
          color: Colors.black,
        ),
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage('images/aaru.png'),
          )
        ],
      ),

      body: Container(
          //  height: MediaQuery.of(context).size.height,
          child: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          TextField(
            decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(
                  Icons.search,
                  size: 30.0,
                  color: Colors.black,
                ),
                fillColor: Colors.grey,
                filled: true,
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10))),
          ),
          SizedBox(
            height: 10,
          ),
          CarouselSlider(
            options: CarouselOptions(
                height: 160.0,
                viewportFraction: 0.8,
                aspectRatio: 16 / 9,
                initialPage: 0,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
                autoPlay: true,
                enableInfiniteScroll: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn),
            items: _carouseImagelList
                .map((element) => sliderImage(image: element))
                .toList(),
          ),
          SizedBox(
            height: 5,
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return Divider(
                  color: Colors.grey,
                );
              },
              itemCount: restaurantNotifier.restaurantList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    restaurantNotifier.currentRestaurant =
                        restaurantNotifier.restaurantList[index];
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ProductsPage();
                    }));
                  },
                  child: restaurantCard(
                      name: restaurantNotifier.restaurantList[index].name,
                      image: restaurantNotifier.restaurantList[index].image),
                );
              },
            ),
          ),
        ],
      )),

      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.red,
        color: Colors.grey[400],
        buttonBackgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        key: _bottomNavigationKey,
        height: 50,
        index: 0,
        items: [
          Icon(
            Icons.home,
            size: 30,
            color: Colors.red,
          ),
          Icon(
            Icons.favorite,
            size: 30,
            color: Colors.red,
          ),
          Icon(
            Icons.shopping_cart,
            size: 30,
            color: Colors.red,
          ),
          Icon(
            Icons.account_circle,
            size: 30,
            color: Colors.red,
          )
        ],
        onTap: (index) {
          _count = index;
        },
      ),
    );
  }

  getRestaurants(RestaurantNotifier restaurantNotifier) async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Restaurants').get();

    List<Restaurant> _restaurantList = [];

    snapshot.docs.forEach((element) {
      Restaurant restaurant = Restaurant.fromMap(element.data());
      _restaurantList.add(restaurant);
    });
    restaurantNotifier.restaurantList = _restaurantList;
  }

  getImages() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Carousel_images').get();

    querySnapshot.docs.forEach((element) {
      _carouseImagelList.add(element.data()['img']);
    });
  }
}
