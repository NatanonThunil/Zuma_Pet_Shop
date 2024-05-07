import 'package:flutter/material.dart';
import '../components/productDetails.dart';

class ClassicTheme {
  static ThemeData themeData = ThemeData(
    primaryColor: Colors.blue, // Set accent color
    fontFamily: 'Georgia', // Set font family
    textTheme: TextTheme(
      headline6: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ), // Set headline style
      subtitle1: TextStyle(
        fontSize: 14,
        color: Color.fromARGB(255, 162, 0, 255), // Custom subtitle color
      ), // Set subtitle style
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.purple),
  );
}

class ProductCard extends StatelessWidget {
  final String productId;
  final String productName;
  final String price;
  final String sold;
  final String storeName;
  final String imageUrl;
  final String details;

  const ProductCard({
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
    return Theme(
      data: ClassicTheme.themeData, // Apply custom theme
      child: Card(
        color: Colors.white,
        elevation: 3,
        margin: EdgeInsets.all(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return showproductdetail(
                  productId: '${productId}',
                  productName: '${productName}',
                  price: '${price}',
                  sold: '${sold}',
                  storeName: '${storeName}',
                  imageUrl: '${imageUrl}',
                  details: '${details}',
                );
              },
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Image.network(
                  imageUrl, // Load image from URL
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      style: Theme.of(context)
                          .textTheme
                          .headline6, // Apply headline style
                    ),
                    Text(
                      storeName,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1, // Apply subtitle style
                    ),
                    SizedBox(height: 5),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$$price',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              fontSize: 25, // Set the font size to 25
                              color: Color.fromARGB(
                                  255, 169, 47, 169), // Custom price text color
                            ),
                      ),
                      Text(
                        '$sold sold',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              fontSize: 15.5,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
