import 'package:flutter/material.dart';
import 'package:zumas_pet_shop/Controllers/like.dart';
import 'package:zumas_pet_shop/models/products.dart';

class Likebtn extends StatefulWidget {
  final bool isLiked;
  final String productId;
  final String productName;
  final Function(bool) onLikeChange; // Function to handle like state change

  const Likebtn(
      {super.key,
      required this.isLiked,
      required this.productId,
      required this.productName,
      required this.onLikeChange});

  @override
  _LikebtnState createState() => _LikebtnState();
}

class _LikebtnState extends State<Likebtn> {
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

class LikePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text('Liked pet'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProductList(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductList() {
    return StreamBuilder<List<Product>>(
      stream: Favorite().readUserProducts(), // Pass null as invoiceId
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<Product> products = snapshot.data ?? [];
          return Column(
            children: products.map((product) {
              return _buildProductCard(product);
            }).toList(),
          );
        }
      },
    );
  }

  Widget _buildProductCard(Product product) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              // Replace CircleAvatar with Image.network
              Image.network(
                product.imgUrl, // Use product.imgUrl for the image URL
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.productName),
                  Text(
                    product.shopName,
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
              Spacer(),
              Likebtn(
                productId: product.id,
                productName: product.productName,
                isLiked: true, // Assuming the product is liked initially
                onLikeChange: (isLiked) {
                  // Handle like state change if needed
                },
              ),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}
