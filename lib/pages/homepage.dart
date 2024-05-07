import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zumas_pet_shop/pages/auth.dart';
import '../components/hambergur.dart';
import 'package:zumas_pet_shop/components/NavBar.dart';
import 'package:zumas_pet_shop/models/products.dart';
import '../components/card.dart';
import '../components/category-btn.dart';
import '../pages/payment.dart';
import '../pages/userProfile.dart';

class HomePage extends StatefulWidget {
  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State with AutomaticKeepAliveClientMixin {
  StretchMode stretchMode = StretchMode.zoomBackground;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 2;
  int productCount = 0;
  String? userBalance = 'Loading...'; // Default balance text
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  // Add a field to keep track of the selected category
  String selectedCategory = 'All';

  // Method to update selected category and trigger rebuild
  void updateCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  void initState() {
    super.initState();
    // Call method to fetch user balance when widget initializes
    _fetchUserBalance();
    // Listen for changes to user balance document in Firestore
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        final balance = snapshot.data()?['balance'] ?? 0;
        setState(() {
          userBalance = balance
              .toString(); // Update userBalance state with fetched balance
        });
      } else {
        setState(() {
          userBalance =
              'Document does not exist'; // Handle case where document does not exist
        });
      }
    });
  }

  Future<void> _fetchUserBalance() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userDoc.exists) {
        final balance = userDoc.data()?['balance'] ?? 0;
        setState(() {
          userBalance = balance
              .toString(); // Update userBalance state with fetched balance
        });
      } else {
        setState(() {
          userBalance =
              'Document does not exist'; // Handle case where document does not exist
        });
      }
    } catch (e) {
      print('Error fetching user balance: $e');
      setState(() {
        userBalance = 'Error'; // Update userBalance state with error message
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // This is required for AutomaticKeepAliveClientMixin
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[200],
      drawer: LeftHambergur(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.black,
            shadowColor: Colors.white,
            leading: IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
            centerTitle: true,
            title: const Text('Z U M A', style: TextStyle(color: Colors.white)),
            expandedHeight: 250,
            stretch: true,
            pinned: true,
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => userProfilePage()));
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  const Image(
                    image: AssetImage('assets/sad.png'),
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.center,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PaymentPage()));
                        },
                        child: Container(
                          height: 80,
                          color: Colors.white,
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Balance",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  Text(
                                    "\$$userBalance",
                                    style: TextStyle(fontSize: 25),
                                  )
                                ],
                              ),
                              Icon(
                                Icons.payments,
                                size: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            // Pass the updateCategory method to the CategoryBTN widget
            child: CategoryBTN(onCategorySelected: updateCategory),
          ),
          StreamBuilder<List<Product>>(
            stream: readProducts(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return SliverToBoxAdapter(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              // Filter products based on the selected category
              final List<Product> products = snapshot.data ?? [];
              final filteredProducts = selectedCategory == 'All'
                  ? products
                  : products
                      .where((product) => product.category == selectedCategory)
                      .toList();

              return SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 20.0,
                  childAspectRatio: 200 / 280,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    if (index >= filteredProducts.length) {
                      return null;
                    }

                    final product =
                        Product.fromJson(filteredProducts[index].toJson());

                    return SizedBox(
                      width: 200.0,
                      height: 280.0,
                      child: ProductCard(
                        productId: product.id,
                        productName: product.productName,
                        price: product.price.toString(),
                        sold: product.soldAmount.toString(),
                        storeName: product.shopName,
                        imageUrl: product.imgUrl,
                        details: product.details.replaceAll("\\n", "\n"),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      // Existing bottomNavigationBar and other Scaffold code...
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Stream<List<Product>> readProducts() => FirebaseFirestore.instance
      .collection('products')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList());

  @override
  bool get wantKeepAlive => true;
}
