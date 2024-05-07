import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:zumas_pet_shop/Controllers/balance.dart';
import '../../components/transactionlist.dart'; // Assuming your Balance class is in a file named balance.dart

class AllTransactionsPage extends StatelessWidget {
  final Balance _balance =
      Balance(); // Create an instance of your Balance class

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All transactions',
          style: TextStyle(fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        elevation: 4,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _balance.streamTransaction(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<Map<String, dynamic>> transactions = snapshot.data ?? [];
            final groupedTransactions = groupTransactionsByDate(transactions);

            return ListView.separated(
              itemCount: groupedTransactions.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                final date = groupedTransactions.keys.toList()[index];
                final transactionsForDate = groupedTransactions[date]!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Text(
                        DateFormat('dd/MM/yyyy HH:mm').format(
                          (transactionsForDate[0]['Transaction Date']
                                  as Timestamp)
                              .toDate(),
                        ),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: transactionsForDate.length,
                      itemBuilder: (context, idx) {
                        final transaction = transactionsForDate[idx];
                        final wcard =
                            transaction['_isReduction'] ? 'Payment' : 'Topup';
                        final isReduction = transaction['_isReduction'] == true;
                        return TL(
                          wcard: wcard,
                          mamount: transaction['Amount'].toString(),
                          inToutF: !transaction['_isReduction'],
                          date: DateFormat('dd/MM/yyyy HH:mm')
                              .format(
                                (transaction['Transaction Date'] as Timestamp)
                                    .toDate(),
                              )
                              .toString(),
                          isReduction:
                              isReduction, // Pass the isReduction value
                          invoiceId: transaction['invoiceId'],
                        );
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }

  Map<String, List<Map<String, dynamic>>> groupTransactionsByDate(
      List<Map<String, dynamic>> transactions) {
    final Map<String, List<Map<String, dynamic>>> groupedTransactions = {};
    List<String> dates = [];

    // Group transactions by date
    for (final transaction in transactions) {
      final date = (transaction['Transaction Date'] as Timestamp)
          .toDate()
          .toString()
          .substring(0, 10);
      if (!groupedTransactions.containsKey(date)) {
        groupedTransactions[date] = [];
        dates.add(date); // Collect dates
      }
      groupedTransactions[date]!.add(transaction);
    }

    // Sort dates in descending order
    dates.sort((a, b) => b.compareTo(a));

    // Create a new map with sorted dates
    final Map<String, List<Map<String, dynamic>>> sortedGroupedTransactions =
        {};
    for (final date in dates) {
      sortedGroupedTransactions[date] = groupedTransactions[date]!;
      // Sort transactions within each date in descending order
      sortedGroupedTransactions[date]!.sort((a, b) =>
          (b['Transaction Date'] as Timestamp)
              .compareTo(a['Transaction Date'] as Timestamp));
    }

    return sortedGroupedTransactions;
  }
}
