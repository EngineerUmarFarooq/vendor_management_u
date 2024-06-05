import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderManagement extends StatefulWidget {
  @override
  _OrderManagementState createState() => _OrderManagementState();
}

class _OrderManagementState extends State<OrderManagement> {
  List<Map<String, dynamic>> _orders = [];
  TextEditingController orderIdController = TextEditingController();
  TextEditingController customerNameController = TextEditingController();
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  Future<void> initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _orders = _prefs
          .getStringList('orders')
          ?.map((order) => jsonDecode(order))
          .cast<Map<String, dynamic>>()
          .toList() ?? [];
    });
  }

  Future<void> addOrder() async {
    Map<String, dynamic> orderData = {
      'order_id': orderIdController.text,
      'customer_name': customerNameController.text,
    };

    List<String> orderList = _prefs.getStringList('orders') ?? [];
    orderList.add(jsonEncode(orderData));
    _prefs.setStringList('orders', orderList);

    setState(() {
      _orders.add(orderData);
    });

    orderIdController.clear();
    customerNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Management'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: orderIdController),
            SizedBox(height: 10.0),
            Text('Customer Name:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: customerNameController),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: addOrder,
              child: Text('Add Order'),
            ),
            SizedBox(height: 20.0),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                final orderData = _orders[index];
                return ListTile(
                  title: Text('Order ID: ${orderData['order_id'] ?? 'N/A'}'),
                  subtitle: Text(
                      'Customer Name: ${orderData['customer_name'] ?? 'N/A'}'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}