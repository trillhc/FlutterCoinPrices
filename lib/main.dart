import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<CoinPrice> fetchCoinPrice() async {
  final response = await http.get(Uri.parse(
      "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin%2Clitecoin%2Cethereum&vs_currencies=usd"));
  if (response.statusCode == 200) {
    return CoinPrice.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load Price of Coin');
  }
}

class CoinPrice {
  final String bitcoin;
  final String litecoin;
  final String ethereum;

  CoinPrice({
    required this.bitcoin,
    required this.litecoin,
    required this.ethereum,
  });

  factory CoinPrice.fromJson(Map<String, dynamic> json) {
    return CoinPrice(
      bitcoin: json['bitcoin']['usd'].toString(),
      litecoin: json['litecoin']['usd'].toString(),
      ethereum: json['ethereum']['usd'].toString(),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<CoinPrice> allPrices;

  @override
  void initState() {
    super.initState();
    allPrices = fetchCoinPrice();
  }

  void _refreshPrices() {
    setState(() {
      allPrices = fetchCoinPrice();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Coin Prices Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Coin Prices Example'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ListTile(
                  title: Text("BTC Price:"),
                  subtitle: FutureBuilder<CoinPrice>(
                    future: allPrices,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text("\$" + snapshot.data!.bitcoin);
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                ),
                ListTile(
                  title: Text("LTC Price:"),
                  subtitle: FutureBuilder<CoinPrice>(
                    future: allPrices,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text("\$" + snapshot.data!.litecoin);
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                ),
                ListTile(
                  title: Text("ETH Price:"),
                  subtitle: FutureBuilder<CoinPrice>(
                    future: allPrices,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text("\$" + snapshot.data!.ethereum);
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _refreshPrices,
          tooltip: 'Refresh Prices',
          child: Icon(Icons.refresh),
        ),
      ),
    );
  }
}
