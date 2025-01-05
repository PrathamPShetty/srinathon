import 'dart:convert'; // For JSON decoding
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http; // For HTTP requests
import 'package:farm_link_ai/consts/ip.dart'; // Import the IP address

class ManageOrder extends StatefulWidget {
  const ManageOrder({super.key});

  @override
  State<ManageOrder> createState() => _OrderState();
}

class _OrderState extends State<ManageOrder> {
  double rating = 3.0; // Initial rating value

  // To track expanded order (showing tracking info)
  final List<bool> _expandedOrder = [];


  // List to store fetched orders
  List<Map<String, dynamic>> orderData = [];

  @override
  void initState() {
    super.initState();
    _fetchOrder(); // Fetch orders on initialization
  }

  Future<void> _fetchOrder() async {
    try {
      final response = await http.get(Uri.parse('$host:8000/api/orders'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          orderData = data.map((json) {
            return {
              'id': json['id'],
              'user': json['user'],
              'service': json['service'],
              'additional_service': json['additional_service'],
              'status1': json['status1'],
              'status2': json['status2'],
              'status3': json['status3'],
            };
          }).toList();
          _expandedOrder.clear();
          _expandedOrder.addAll(List.generate(orderData.length, (index) => false));
        });
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      debugPrint('Error fetching orders: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Service Orders")),
      body: orderData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: orderData.length,
          itemBuilder: (context, index) {
            var order = orderData[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
              child: Column(
                children: [
                  ListTile(
                    title: Text('Service: ${order['service']}'),
                    subtitle: Text(
                        'Additional Service: ${order['additional_service']}\nStatus: ${order['status1']}, ${order['status2']}, ${order['status3']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Cancel Order Button
                        IconButton(
                          icon: const Icon(Icons.cancel),
                          onPressed: () => showCancelDialog(
                              context, order['service'], order['id']),
                        ),
                        // Rating Button
                        IconButton(
                          icon: const Icon(Icons.star_rate),
                          onPressed: () => showRatingDialog(context),
                        ),
                      ],
                    ),
                    leading: const Icon(
                      Icons.shopping_cart,
                      size: 50,
                      color: Colors.blueAccent,
                    ),
                  ),
                  // Order Tracking Button / Expansion Tile
                  ExpansionTile(
                    title: const Text("Order Tracking"),
                    children: [
                      Stepper(
                        currentStep: 2, // Simulating the current step in order
                        onStepTapped: (step) {
                          setState(() {
                            // Move to different steps if needed
                          });
                        },
                        steps: [
                          Step(
                            title: const Text('Confirmed'),
                            content: const Text('Order is confirmed.'),
                            isActive: order['status1'] == true,
                          ),
                          Step(
                            title: const Text('Prepared'),
                            content: const Text('Order is being prepared.'),
                            isActive: order['status2'] == true,
                          ),
                          Step(
                            title: const Text('Dispatched'),
                            content: const Text(''),
                            isActive: order['status3'] == true,
                          ),
                        ],
                      ),
                    ],
                    onExpansionChanged: (expanded) {
                      setState(() {
                        _expandedOrder[index] = expanded;
                      });
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Cancel Order Dialog
  void showCancelDialog(BuildContext context, String service, int orderId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cancel Order'),
          content: Text(
              'Are you sure you want to cancel the order of $service with ID: $orderId?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                // Handle cancel order logic here
                Navigator.of(context).pop();
              },
              child: const Text('Yes, Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Rating Order Dialog
  void showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Rate your order experience'),
          content: SingleChildScrollView(
            // Makes the content scrollable
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RatingBar.builder(
                  initialRating: rating,
                  minRating: 1,
                  itemSize: 40,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                  onRatingUpdate: (rating) {
                    setState(() {
                      this.rating = rating;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Icon(
                      Icons.star,
                      color: index < rating ? Colors.yellow : Colors.grey,
                    );
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: const InputDecoration(hintText: 'Enter feedback'),
                  maxLines: 3,
                  onChanged: (value) {
                    // Handle feedback input
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Submit rating and feedback logic here
                Navigator.of(context).pop();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
