import 'package:flutter/material.dart';
import 'package:farm_link_ai/ui/commons/nav_bar/navbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:farm_link_ai/consts/ip.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Order> recentOrders = [];

  @override
  void initState() {
    super.initState();
    _fetchOrder();
  }

  // Fetching orders from the API
  Future<void> _fetchOrder() async {
    try {
      final response = await http.get(Uri.parse('$host:8000/api/orders'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          recentOrders = data.map((json) {
            return Order(
              id: json['id'],
              user: json['user'],
              service: json['service'],
              additionalService: json['additional_service'],
              status1: json['status1'],
              status2: json['status2'],
              status3: json['status3'],
            );
          }).toList();
        });
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      debugPrint('Error fetching orders: $e');
      setState(() {
        recentOrders = [];  // Clear existing orders in case of error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final int totalCustomers = 50;
    final int totalOrders = 100;
    final double totalRevenue = 5000.0;

    return NavBar(
      bodyContent: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),

              // Total Values Cards (Customers, Orders, Revenue)
              LayoutBuilder(
                builder: (context, constraints) {
                  int columns = (constraints.maxWidth > 600) ? 3 : 2;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 20.0,
                      mainAxisSpacing: 20.0,
                      childAspectRatio: 1.6,
                    ),
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _buildTotalCard(
                          context,
                          "Customers",
                          totalCustomers.toString(),
                          Icons.people_alt,
                          Colors.teal,
                        );
                      } else {
                        return _buildTotalCard(
                          context,
                          "Orders",
                          totalOrders.toString(),
                          Icons.shopping_cart,
                          Colors.orange,
                        );
                      }
                    },
                  );
                },
              ),

              const SizedBox(height: 30),

              // Recent Orders Section
              Text(
                "Recent Orders",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              recentOrders.isEmpty
                  ? Center(
                child: Text(
                  "No orders to display",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              )
                  : Column(
                children: recentOrders.take(7).map((order) { // Display only 7 orders
                  return _buildOrderCard(order);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for building total cards (e.g., Total Customers, Orders, Revenue)
  Widget _buildTotalCard(
      BuildContext context,
      String label,
      String value,
      IconData icon,
      Color color,
      ) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              icon,
              color: color,
              size: 35,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget for building individual order cards
  Widget _buildOrderCard(Order order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      child: ListTile(
        leading: Icon(
          Icons.assignment,
          color: Colors.blueAccent,
          size: 40,
        ),
        title:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Service: ${order.user}"),
            Text("Additional Service: ${order.additionalService}"),
            Text("Status1: ${order.status1}, Status2: ${order.status2}, Status3: ${order.status3}"),
          ],
        ),
        trailing: Text(
          "\$0.00",  // Replace with actual total amount if available
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
    );
  }
}

// Order class to represent each order
class Order {
  final String id;
  final String user;
  final String service;
  final String additionalService;
  final String status1;
  final String status2;
  final String status3;

  Order({
    required this.id,
    required this.user,
    required this.service,
    required this.additionalService,
    required this.status1,
    required this.status2,
    required this.status3,
  });
}