import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zumas_pet_shop/Controllers/balance.dart';
import '../../pages/allTransactions.dart';
import '../components/normalAlert.dart';

TextEditingController _controller = TextEditingController();
double amount = 0;

class Numinputonly extends StatefulWidget {
  @override
  _Numinputonly createState() => _Numinputonly();
}

class _Numinputonly extends State {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      ],
      decoration: InputDecoration(
        hintText: 'Enter a number only',
      ),
    );
  }
}

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State {
  String _userBalance = 'Loading...'; // Default value

  @override
  void initState() {
    super.initState();
    _subscribeToBalanceUpdates();
  }

  void _subscribeToBalanceUpdates() {
    Balance().readUserBalance().listen((balance) {
      setState(() {
        _userBalance = balance;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Payment'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 25,
          ),
          Center(
            child: Container(
              constraints: BoxConstraints(
                minWidth: 400,
                maxHeight: 200,
              ),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Balance',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '\$ $_userBalance', // Show user's balance here
                          style: TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: 400,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Top-Up'),
                                  content: Container(
                                    height: 110,
                                    width: 150,
                                    child: Column(
                                      children: [
                                        Text(
                                            'Input how much fake money you want.'),
                                        Numinputonly(),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              amount = double.parse(
                                                  _controller.text);

                                              if (amount > 0) {
                                                Balance().topup(amount);
                                                Navigator.of(context).pop();
                                              } else {
                                                NormAlert(
                                                        atitle: 'Warning...',
                                                        acontext:
                                                            'Please input amount')
                                                    .show(context);
                                              }
                                              ;
                                            },
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: Container(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 20,
                                                    right: 20,
                                                    top: 10,
                                                    bottom: 10),
                                                child: Text('Confirm'),
                                              ),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Colors.black),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                            )),
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Container(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 20,
                                                  right: 20,
                                                  top: 10,
                                                  bottom: 10),
                                              child: Text('Close'),
                                            ),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 1,
                                                    color: Colors.black),
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              });
                        },
                        splashColor: Colors.cyan,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.account_balance_wallet_outlined,
                                  color: Colors.black),
                              SizedBox(width: 8),
                              Text(
                                'Top-Up',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Center(
            child: Container(
                width: 400,
                height: 69,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        //// show
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Recent transactions',
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AllTransactionsPage()),
                                );
                              },
                              icon: Icon(
                                Icons.arrow_forward,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
