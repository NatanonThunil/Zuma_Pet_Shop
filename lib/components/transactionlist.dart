import 'package:flutter/material.dart';
import 'package:zumas_pet_shop/pages/Succesbuy.dart';

class TL extends StatelessWidget {
  final String wcard;
  final String mamount;
  final String date;
  final bool inToutF;
  final bool isReduction;
  final String? invoiceId; // New parameter to receive InvoiceId

  const TL({
    Key? key,
    required this.wcard,
    required this.mamount,
    required this.inToutF,
    required this.date,
    required this.isReduction,
    required this.invoiceId, // Initialize it as nullable
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Transaction details'),
              content: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: Text(
                            inToutF ? 'Top-up' : 'Payment',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                inToutF ? 'You\'ve topped up' : 'You\'ve paid'),
                            Text(
                              inToutF ? '+\$$mamount' : '-\$$mamount',
                              style: TextStyle(
                                  fontSize: 30,
                                  color: inToutF ? Colors.green : Colors.red),
                            )
                          ],
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Using payment method'),
                            Text('$wcard')
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Date and time'),
                            Text('$date'),
                          ],
                        ),
                      ),
                      if (isReduction) // Conditionally add the button
                        Divider(),
                      if (isReduction) // Conditionally add the button
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SuccessBuy(invoiceId: invoiceId as String),
                              ),
                            );
                          },
                          child: Text('View Invoice'),
                        ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.black),
                      ),
                      backgroundColor: Colors.transparent),
                  child: Center(
                    child: Text(
                      'Close',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              backgroundColor: Colors.white,
              elevation: 4.0,
            );
          },
        );
      },
      child: ListTile(
        title: Text(inToutF ? 'Top-up' : 'Payment'),
        subtitle: Text(
          '${wcard}',
          style: TextStyle(color: Colors.grey),
        ),
        trailing: Text(
          inToutF ? '+ \$$mamount' : '- \$$mamount',
          style: TextStyle(
            color: inToutF ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
