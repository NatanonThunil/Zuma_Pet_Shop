import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zumas_pet_shop/models/products.dart';
import 'package:zumas_pet_shop/Controllers/invoice.dart';
import 'package:zumas_pet_shop/pages/homepage.dart';

class SuccessBuy extends StatelessWidget {
  final String invoiceId;

  SuccessBuy({required this.invoiceId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Invoice'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<Map<String, dynamic>>(
          stream: Invoice().streamInvoiceInformation(invoiceId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('No data available'));
            } else {
              final invoiceData = snapshot.data!;
              final remainingBalance =
                  (invoiceData['Final Balance'] as num).toStringAsFixed(2);
              final dateAdded = (invoiceData['Date Added'] as Timestamp)
                  .toDate()
                  .toString()
                  .substring(0, 16); // Format the date as DD/MM/YYYY HH:MM
              return Center(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Image.asset(
                      "assets/zuma-icon.png",
                      fit: BoxFit.cover,
                      height: 150,
                      width: 150,
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Divider(),
                          Text('Invoice ID: ${invoiceData['Invoice ID']}'),
                          Divider(),
                          Row(
                            children: [Text('List of items')],
                          ),
                          SizedBox(height: 5),
                          StreamBuilder<List<Product>>(
                            stream: Invoice().readUserProducts(invoiceId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text('Error: ${snapshot.error}'),
                                );
                              } else {
                                final List<Product> products = snapshot.data!;
                                return Column(
                                  children: products.map((product) {
                                    return ListTile(
                                      title: Text(product.productName),
                                      trailing: Text(
                                        '\$${product.price}',
                                        style: TextStyle(fontSize: 16.5),
                                      ),
                                    );
                                  }).toList(),
                                );
                              }
                            },
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Paid totals'),
                              Text('-\$${invoiceData['Total Price']}'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Remaining balance'),
                              Text('\$$remainingBalance'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Date'),
                              Text('$dateAdded'),
                            ],
                          ),
                          Divider(),
                        ],
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 1.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Back to home page',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
