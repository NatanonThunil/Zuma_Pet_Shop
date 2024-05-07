import 'package:flutter/material.dart';
import 'package:zumas_pet_shop/Controllers/cart.dart';
import 'package:zumas_pet_shop/Controllers/like.dart'; // Import the Favorite class

class showproductdetail extends StatelessWidget {
  final String productId;
  final String productName;
  final String price;
  final String sold;
  final String storeName;
  final String imageUrl;
  final String details;

  const showproductdetail({
    Key? key,
    required this.productId,
    required this.productName,
    required this.price,
    required this.sold,
    required this.storeName,
    required this.imageUrl,
    required this.details,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Details'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: 300,
                  height: 300,
                ),
              ),
            ),
            SizedBox(height: 10),
            Divider(),
            Column(
              children: [
                Text(
                  productName,
                  style: TextStyle(fontSize: 30),
                ),
                Text(
                  '\$$price',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.blue,
                  ),
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
            _ExtendDetail(showdetaila: details),
            Text('Store: $storeName'),
            Text('Sold: $sold'),
            SizedBox(height: 10),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LikeProduct(
              productId: productId,
              productName: productName,
              isLiked:
                  true, // Here, you might want to pass the initial liked status based on your data
            ),
            Row(
              children: [
                FutureBuilder<bool>(
                  future: Cart().isExist(productId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else {
                      bool isExist = snapshot.data ?? false;
                      return Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(20)),
                        child: InkWell(
                          onTap: isExist
                              ? () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('N O'),
                                          content: Text(
                                              'This item already in cart you can edit in your cart'),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text('OK...'))
                                          ],
                                        );
                                      });
                                }
                              : () async {
                                  Cart().addItemToCart(productId, productName);
                                  Navigator.of(context).pop();
                                },
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                                isExist ? 'Already in Cart' : 'Add to Cart'),
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      );
                    }
                  },
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}

class _ExtendDetail extends StatefulWidget {
  final String showdetaila;

  const _ExtendDetail({Key? key, required this.showdetaila}) : super(key: key);

  @override
  __ExtendDetailState createState() => __ExtendDetailState();
}

class __ExtendDetailState extends State<_ExtendDetail> {
  bool isShown = false;
  int maxLine = 5;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(
        widget.showdetaila,
        maxLines: isShown ? null : maxLine,
        overflow: isShown ? TextOverflow.visible : TextOverflow.ellipsis,
      ),
      const SizedBox(
        height: 10,
      ),
      InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          setState(
            () {
              isShown = !isShown;
            },
          );
        },
        child: Container(
          child: Row(
            children: [
              Text(
                isShown ? 'Show less' : 'Show more',
              ),
              Icon(isShown
                  ? Icons.expand_less_outlined
                  : Icons.expand_more_outlined)
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(20)),
        ),
      ),
    ]);
  }
}

class LikeProduct extends StatefulWidget {
  final String productId;
  final String productName;
  final bool isLiked;

  LikeProduct({
    Key? key,
    required this.productId,
    required this.productName,
    required this.isLiked,
  }) : super(key: key);

  @override
  _LikeProductState createState() => _LikeProductState();
}

class _LikeProductState extends State<LikeProduct> {
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    // You need to pass the productId to alreadyFavorite method
    Favorite().alreadyFavorite(widget.productId).then((value) {
      setState(() {
        isLiked = value; // Update isLiked based on the result
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        setState(() {
          isLiked = !isLiked;
        });

        try {
          // Call the toggleFavoriteStatus method from the Favorite class
          await Favorite().toggleFavoriteStatus(
            widget.productId,
            widget.productName,
          );
        } catch (error) {
          // Handle errors if necessary
          print('Error toggling favorite status: $error');
          // Revert isLiked state in case of error
          setState(() {
            isLiked = !isLiked;
          });
        }
      },
      icon: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border,
      ),
    );
  }
}
