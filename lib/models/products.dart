class Product {
  String id;
  final String productName;
  final String shopName;
  final int price;
  final int soldAmount;
  final String imgUrl;
  final String details;
  final String category;

  Product({
    required this.id,
    required this.productName,
    required this.shopName,
    required this.price,
    required this.soldAmount,
    required this.imgUrl,
    required this.details,
    required this.category,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'productName': productName,
        'shopName': shopName,
        'price': price,
        'soldAmount': soldAmount,
        'imgUrl': imgUrl,
        'details': details,
      };

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      productName: json['productName'] ?? 'Unknown Product',
      shopName: json['shopName'] ?? 'Unknown Shop',
      price: json['price'] ?? 0,
      soldAmount: json['soldAmount'] ?? 0,
      imgUrl: json['imgUrl'] ?? '',
      details: json['details'] ?? '',
      category: json['Category'] ?? '',
    );
  }
}
