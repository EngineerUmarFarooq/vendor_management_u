import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductManagement extends StatefulWidget {
  @override
  _ProductManagementState createState() => _ProductManagementState();
}

class _ProductManagementState extends State<ProductManagement> {
  List<dynamic> _products = [];
  TextEditingController productIdController = TextEditingController();
  TextEditingController productNameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  TextEditingController supplierController = TextEditingController();
  late SharedPreferences _prefs;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  Future<void> initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _products = _prefs
          .getStringList('products')
          ?.map((product) => jsonDecode(product))
          .toList() ??
          [];
    });
  }

  Future<void> addProduct() async {
    if (productIdController.text.isEmpty || productNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product ID and Product Name are required'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    Map<String, dynamic> productData = {
      'product_id': productIdController.text,
      'product_name': productNameController.text,
      'category': categoryController.text,
      'price': priceController.text,
      'stock': stockController.text,
      'supplier': supplierController.text,
    };

    List<String> productList = _prefs.getStringList('products') ?? [];
    productList.add(jsonEncode(productData));
    _prefs.setStringList('products', productList);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Product added successfully'),
        backgroundColor: Colors.blueAccent,
      ),
    );

    initPrefs(); // Refresh the list after adding a product

    productIdController.clear();
    productNameController.clear();
    categoryController.clear();
    priceController.clear();
    stockController.clear();
    supplierController.clear();
    setState(() {
      _selectedIndex = null;
    });
  }

  Future<void> updateProduct() async {
    if (_selectedIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a product to update'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    Map<String, dynamic> productData = {
      'product_id': productIdController.text,
      'product_name': productNameController.text,
      'category': categoryController.text,
      'price': priceController.text,
      'stock': stockController.text,
      'supplier': supplierController.text,
    };

    List<String> productList = _prefs.getStringList('products') ?? [];
    productList[_selectedIndex!] = jsonEncode(productData);
    _prefs.setStringList('products', productList);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Product updated successfully'),
        backgroundColor: Colors.blueAccent,
      ),
    );

    initPrefs(); // Refresh the list after updating a product

    productIdController.clear();
    productNameController.clear();
    categoryController.clear();
    priceController.clear();
    stockController.clear();
    supplierController.clear();
    setState(() {
      _selectedIndex = null;
    });
  }

  Future<void> deleteProduct(int index) async {
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this product?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      setState(() {
        _products.removeAt(index);
        _prefs.setStringList('products',
            _products.map((product) => jsonEncode(product)).toList());
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product deleted successfully'),
          backgroundColor: Colors.blueAccent,
        ),
      );
    }
  }

  void editProduct(int index, Map<String, dynamic> productData) {
    setState(() {
      _selectedIndex = index;
      productIdController.text = productData['product_id'];
      productNameController.text = productData['product_name'];
      categoryController.text = productData['category'];
      priceController.text = productData['price'];
      stockController.text = productData['stock'];
      supplierController.text = productData['supplier'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Management'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Product ID:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: productIdController),
            SizedBox(height: 10.0),
            Text('Product Name:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: productNameController),
            SizedBox(height: 10.0),
            Text('Category:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: categoryController),
            SizedBox(height: 10.0),
            Text('Price:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: priceController),
            SizedBox(height: 10.0),
            Text('Stock:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: stockController),
            SizedBox(height: 10.0),
            Text('Supplier:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: supplierController),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _selectedIndex != null ? updateProduct : addProduct,
                  child: Text(_selectedIndex != null ? 'Update Product' : 'Add Product'),
                ),
                ElevatedButton(
                  onPressed: () {
                    productIdController.clear();
                    productNameController.clear();
                    categoryController.clear();
                    priceController.clear();
                    stockController.clear();
                    supplierController.clear();
                    setState(() {
                      _selectedIndex = null;
                    });
                  },
                  child: Text('Clear'),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final productData = _products[index];
                return ListTile(
                  title: Text('Product ID: ${productData['product_id'] ?? 'N/A'}'),
                  subtitle: Text('Product Name: ${productData['product_name'] ?? 'N/A'}'),
                  onTap: () {
                    _showProductInfoDialog(context, productData);
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => editProduct(index, productData),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => deleteProduct(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showProductInfoDialog(BuildContext context, Map<String, dynamic> productData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Product Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Product ID: ${productData['product_id'] ?? 'N/A'}'),
              Text('Product Name: ${productData['product_name'] ?? 'N/A'}'),
              Text('Category: ${productData['category'] ?? 'N/A'}'),
              Text('Price: ${productData['price'] ?? 'N/A'}'),
              Text('Stock: ${productData['stock'] ?? 'N/A'}'),
              Text('Supplier: ${productData['supplier'] ?? 'N/A'}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}