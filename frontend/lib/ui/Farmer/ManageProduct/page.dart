import 'package:flutter/material.dart';
import 'package:vtable/vtable.dart';

import '../../commons/nav_bar/NavBar.dart';

class ManageProduct extends StatefulWidget {
  const ManageProduct({super.key});

  @override
  State<ManageProduct> createState() => _ManageProductState();
}

class _ManageProductState extends State<ManageProduct> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> allProducts = [
    Product(name: "Product A", price: 100, description: "High-quality seeds", status: "Available"),
    Product(name: "Product B", price: 150, description: "Organic fertilizer", status: "Unavailable"),
    Product(name: "Product C", price: 200, description: "Crop protector", status: "Available"),
  ];
  List<Product> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    filteredProducts = allProducts; // Initialize with all products
  }

  void _filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProducts = allProducts;
      } else {
        filteredProducts = allProducts
            .where((product) => product.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _handleManageAction(Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Manage ${product.name}"),
        content: const Text("Edit or delete functionality can go here."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NavBar(
      bodyContent: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              onChanged: _filterProducts,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Search products here...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Products Table
            Expanded(
              child: filteredProducts.isEmpty
                  ? Center(
                child: Text(
                  "No products found!",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              )
                  : VTable<Product>(
                items: filteredProducts,
                columns: [
                  VTableColumn(
                    label: 'Product',
                    transformFunction: (product) => product.name,
                    width: 75,
                  ),
                  VTableColumn(
                    label: 'Price',
                    transformFunction: (product) => '\$${product.price.toString()}',
                    alignment: Alignment.centerRight,
                    width: 70,
                  ),
                  VTableColumn(
                    label: 'Description',
                    transformFunction: (product) => product.description,
                    width: 80,
                  ),
                  VTableColumn(
                    label: 'Status',
                    transformFunction: (product) => product.status,
                    width: 83,
                  ),
                  VTableColumn(
                    label: 'Actions',
                    transformFunction: (product) => "Manage",
                    width: 80,
                  ),
                ],
                onDoubleTap: (product) => _handleManageAction(product),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Product {
  final String name;
  final double price;
  final String description;
  final String status;

  Product({
    required this.name,
    required this.price,
    required this.description,
    required this.status,
  });
}
