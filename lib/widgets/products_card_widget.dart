import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductsCard extends StatefulWidget {
  final Function setViewCart;
  final Function addToTotalItems;
  final Function deleteTotalItems;
  final String name;
  final String image;
  final int price;

  const ProductsCard({
    Key key,
    this.name,
    this.image,
    this.price,
    this.addToTotalItems,
    this.deleteTotalItems,
    this.setViewCart,
  }) : super(key: key);
  @override
  _ProductsCardState createState() => _ProductsCardState();
}

class _ProductsCardState extends State<ProductsCard> {
  int itemAmount;
  itemCal() {
    itemAmount = widget.price * count;
  }

  int count = 0;
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
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
                      widget.name,
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
                      '₹ ' + widget.price.toString(),
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
                          image: NetworkImage(widget.image), fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
              Positioned(
                bottom: -5,
                left: 20,
                child: RaisedButton(
                  onPressed: () {
                    widget.addToTotalItems();
                    widget.setViewCart();

                    setState(() {
                      count++;
                      isVisible = true;
                      itemCal();
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
                  visible: isVisible,
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
                            widget.setViewCart();

                            widget.deleteTotalItems();
                            setState(() {
                              if (count > 0) {
                                count--;
                                itemCal();
                              } else {
                                isVisible = false;
                              }
                            });
                          },
                          color: Colors.white,
                        ),
                        Text(
                          count.toString(),
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            widget.setViewCart();

                            widget.addToTotalItems();
                            setState(() {
                              count++;
                              itemCal();
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
}
