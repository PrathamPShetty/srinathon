import 'package:flutter/material.dart';

class AppPage extends StatelessWidget {
  final Widget bodyContent; // Dynamic page content
  final String title; // Page title

  const AppPage({
    Key? key,
    required this.bodyContent,
    this.title = 'Farm Link AI',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFFEDDD5E),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/banner-2.jpg'),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Welcome!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF404A3D),
                    ),
                  ),
                ],
              ),
            ),
            _drawerItem(Icons.home, 'Home', () {
              // Add navigation logic
            }),
            _drawerItem(Icons.info, 'About Us', () {
              // Add navigation logic
            }),
            _drawerItem(Icons.contact_phone, 'Contact', () {
              // Add navigation logic
            }),
            _drawerItem(Icons.shopping_cart, 'Product', () {
              // Add navigation logic
            }),
            _drawerItem(Icons.shopping_bag, 'Order', () {
              // Add navigation logic
            }),
            _drawerItem(Icons.logout, 'Logout', () {
              // Add logout logic
            }),
          ],
        ),
      ),
      body: bodyContent,
    );
  }

  Widget _drawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF404A3D)),
      title: Text(
        title,
        style: const TextStyle(color: Color(0xFF404A3D)),
      ),
      onTap: onTap,
    );
  }
}
