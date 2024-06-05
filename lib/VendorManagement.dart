import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VendorManagement extends StatefulWidget {
  @override
  _VendorState createState() => _VendorState();
}

class _VendorState extends State<VendorManagement> {
  List<dynamic> _vendors = [];
  TextEditingController vendorIdController = TextEditingController();
  TextEditingController vendorNameController = TextEditingController();
  TextEditingController contactPersonController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController numProductsController = TextEditingController();
  List<String> productNames = [];
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
      _vendors = _prefs
          .getStringList('vendors')
          ?.map((vendor) => jsonDecode(vendor))
          .toList() ??
          [];
    });
  }

  Future<void> addVendor() async {
    if (vendorIdController.text.isEmpty || vendorNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vendor ID and Vendor Name are required'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    Map<String, dynamic> vendorData = {
      'vendor_id': vendorIdController.text,
      'vendor_name': vendorNameController.text,
      'contact_person': contactPersonController.text,
      'telephone': telephoneController.text,
      'email': emailController.text,
      'num_products': numProductsController.text,
      'product_names': productNames,
    };

    List<String> vendorList = _prefs.getStringList('vendors') ?? [];
    vendorList.add(jsonEncode(vendorData));
    _prefs.setStringList('vendors', vendorList);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Vendor added successfully'),
        backgroundColor: Colors.blueAccent,
      ),
    );

    initPrefs(); // Refresh the list after adding a vendor

    vendorIdController.clear();
    vendorNameController.clear();
    contactPersonController.clear();
    telephoneController.clear();
    emailController.clear();
    numProductsController.clear();
    productNames.clear();
    setState(() {
      _selectedIndex = null;
    });
  }

  Future<void> updateVendor() async {
    if (_selectedIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a vendor to update'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    Map<String, dynamic> vendorData = {
      'vendor_id': vendorIdController.text,
      'vendor_name': vendorNameController.text,
      'contact_person': contactPersonController.text,
      'telephone': telephoneController.text,
      'email': emailController.text,
      'num_products': numProductsController.text,
      'product_names': productNames,
    };

    List<String> vendorList = _prefs.getStringList('vendors') ?? [];
    vendorList[_selectedIndex!] = jsonEncode(vendorData);
    _prefs.setStringList('vendors', vendorList);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Vendor updated successfully'),
        backgroundColor: Colors.blueAccent,
      ),
    );

    initPrefs(); // Refresh the list after updating a vendor

    vendorIdController.clear();
    vendorNameController.clear();
    contactPersonController.clear();
    telephoneController.clear();
    emailController.clear();
    numProductsController.clear();
    productNames.clear();
    setState(() {
      _selectedIndex = null;
    });
  }

  Future<void> deleteVendor(int index) async {
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this vendor?'),
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
        _vendors.removeAt(index);
        _prefs.setStringList('vendors',
            _vendors.map((vendor) => jsonEncode(vendor)).toList());
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vendor deleted successfully'),
          backgroundColor: Colors.blueAccent,
        ),
      );
    }
  }

  void editVendor(int index, Map<String, dynamic> vendorData) {
    setState(() {
      _selectedIndex = index;
      vendorIdController.text = vendorData['vendor_id'];
      vendorNameController.text = vendorData['vendor_name'];
      contactPersonController.text = vendorData['contact_person'];
      telephoneController.text = vendorData['telephone'];
      emailController.text = vendorData['email'];
      numProductsController.text = vendorData['num_products'];
      productNames = List<String>.from(vendorData['product_names']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vendor Management'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Vendor ID:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: vendorIdController),
            SizedBox(height: 10.0),
            Text('Vendor Name:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: vendorNameController),
            SizedBox(height: 10.0),
            Text('Contact Person:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: contactPersonController),
            SizedBox(height: 10.0),
            Text('Telephone Number:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: telephoneController),
            SizedBox(height: 10.0),
            Text('Email:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: emailController),
            SizedBox(height: 10.0),
            Text('Number of Products:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: numProductsController),
            SizedBox(height: 10.0),
            Text('Product Names:', style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: productNames
                  .map((product) => Chip(
                label: Text(product),
                onDeleted: () {
                  setState(() {
                    productNames.remove(product);
                  });
                },
              ))
                  .toList(),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    String newProductName =
                        ''; // Store the new product name here
                    return AlertDialog(
                      title: Text('Add Product Name'),
                      content: TextField(
                        onChanged: (value) {
                          // Store the value in a variable but don't update the state yet
                          newProductName = value;
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter product name',
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              // Add the product name to the list only when the "Add" button is pressed
                              productNames.add(newProductName);
                            });
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text('Add'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Add Product'),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _selectedIndex != null ? updateVendor : addVendor,
                  child: Text(_selectedIndex != null ? 'Update Vendor' : 'Add Vendor'),
                ),
                ElevatedButton(
                  onPressed: () {
                    vendorIdController.clear();
                    vendorNameController.clear();
                    contactPersonController.clear();
                    telephoneController.clear();
                    emailController.clear();
                    numProductsController.clear();
                    productNames.clear();
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
              itemCount: _vendors.length,
              itemBuilder: (context, index) {
                final vendorData = _vendors[index];
                return ListTile(
                  title: Text('Vendor ID: ${vendorData['vendor_id'] ?? 'N/A'}'),
                  subtitle: Text('Vendor Name: ${vendorData['vendor_name'] ?? 'N/A'}'),
                  onTap: () {
                    _showVendorInfoDialog(context, vendorData);
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          editVendor(index, vendorData);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          deleteVendor(index);
                        },
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

  void _showVendorInfoDialog(BuildContext context, Map<String, dynamic> vendorData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Vendor Information'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Vendor ID: ${vendorData['vendor_id'] ?? 'N/A'}'),
                SizedBox(height: 10),
                Text('Vendor Name: ${vendorData['vendor_name'] ?? 'N/A'}'),
                SizedBox(height: 10),
                Text('Contact Person: ${vendorData['contact_person'] ?? 'N/A'}'),
                SizedBox(height: 10),
                Text('Telephone: ${vendorData['telephone'] ?? 'N/A'}'),
                SizedBox(height: 10),
                Text('Email: ${vendorData['email'] ?? 'N/A'}'),
                SizedBox(height: 10),
                Text('Number of Products: ${vendorData['num_products'] ?? 'N/A'}'),
                SizedBox(height: 10),
                Text('Product Names:'),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: (vendorData['product_names'] as List<dynamic>?)
                      ?.map((product) => Chip(label: Text(product)))
                      .toList() ??
                      [],
                ),
              ],
            ),
          ),
          actions: [
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