import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:farm_link_ai/consts/assets.dart' as consts;
import 'package:farm_link_ai/utils/hive_utils.dart';

class NavBar extends StatefulWidget {
  final Widget bodyContent; // Dynamic page content
  final String title;

  const NavBar({
    super.key,
    required this.bodyContent,
    this.title = 'ServiceHive',
  });

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  late bool isFarmer;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeUserType();
  }

  Future<void> _initializeUserType() async {
    try {
      isFarmer = await HiveUtils.getUserType();
    } catch (e) {
      isFarmer = false; // Default to customer in case of error
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFF404A3D)),
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
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xffffffff),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(consts.service),
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
            if (!isLoading) ..._getMenuItems(context),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : widget.bodyContent,
    );
  }

  /// Generates menu items based on user type
  List<Widget> _getMenuItems(BuildContext context) {
    return isFarmer ? _farmerMenuItems(context) : _customerMenuItems(context);
  }

  /// Farmer menu items
  List<Widget> _farmerMenuItems(BuildContext context) {
    return [
      _drawerItem(context, Icons.home, 'Dashboard', '/farmer'),
      _drawerItem(context, Icons.info, 'Products', '/farmer/product'),
      _drawerItem(context, Icons.contact_phone, 'Orders', '/farmer/order'),
      // _drawerItem(context, Icons.shopping_cart, 'Recommend Crop', '/farmer/recommend-crop'),
      // _drawerItem(context, Icons.shopping_bag, 'Recommend Fertilizer', '/farmer/recommend-fertilizer'),
      // _drawerItem(context, Icons.shopping_bag, 'Detect Crop Disease', '/farmer/detect-crop'),
      _drawerItem(context, Icons.logout, 'Logout', '', isLogout: true),
    ];
  }

  /// Customer menu items
  List<Widget> _customerMenuItems(BuildContext context) {
    return [
      _drawerItem(context, Icons.home, 'Home', '/customer'),
      _drawerItem(context, Icons.info, 'About Us', '/customer/about'),
      _drawerItem(context, Icons.contact_phone, 'Contact', '/customer/contact'),
      _drawerItem(context, Icons.shopping_cart, 'Services', '/customer/product'),
      _drawerItem(context, Icons.shopping_bag, 'Order', '/customer/order'),
      // _drawerItem(context, Icons.payment, 'Payment', '/customer/payment'),
      _drawerItem(context, Icons.payment, 'Chat', '/customer/assistant'),
      _drawerItem(context, Icons.logout, 'Logout', '', isLogout: true)

    ];
  }

  /// Drawer item widget
  Widget _drawerItem(BuildContext context, IconData icon, String title, String route,
      {bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF404A3D)),
      title: Text(
        title,
        style: const TextStyle(color: Color(0xFF404A3D)),
      ),
      onTap: () async {
        if (isLogout) {
          final confirm = await _showLogoutDialog(context);
          if (confirm) {
            await HiveUtils.deleteAll();
            context.go('/login');
          }
        } else {
          context.go(route); // Navigate to route
          Navigator.pop(context); // Close the drawer
        }
      },
    );
  }

  Future<bool> _showLogoutDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // Return false
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), // Return true
            child: const Text('Logout'),
          ),
        ],
      ),
    );
    return result ?? false; // Return false if result is null
  }

}
