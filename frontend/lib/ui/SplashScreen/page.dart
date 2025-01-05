import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../consts/assets.dart';
// Replace with your asset paths

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isCheckingPermissions = true;

  @override
  void initState() {
    super.initState();
    checkAndRequestPermissions();
  }

  /// Check and request permissions
  Future<void> checkAndRequestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.storage,
      Permission.photos,
      Permission.location
    ].request();

    // Handle statuses
    statuses.forEach((permission, status) {
      if (status.isDenied) {
        debugPrint('$permission permission denied.');
      } else if (status.isPermanentlyDenied) {
        debugPrint(
            '$permission permission permanently denied. Open settings to grant.');
      } else {
        debugPrint('$permission permission granted.');
      }
    });

    // Simulate a delay to show shimmer for a few seconds
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      isCheckingPermissions = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF34b3a0), Color(0xFF0288d1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Main content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Lottie Animation
              Expanded(
                flex: 3,
                child: Center(
                  child: Lottie.asset(
                    loadingAnimation, // Replace with your Lottie JSON path
                    width: 220,
                    height: 220,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Title and Subtitle
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome to ServiceHive!',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Get ready to explore new horizons',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),

                  ],
                ),
              ),

              // Get Started Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0), // Adjust horizontal padding
                child: SizedBox(
                  height: 50,
                  width: 200,
                  // Set a fixed height for the button
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2), // Subtle transparent background
                      foregroundColor: Colors.white, // White text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Rounded corners
                      ),
                      elevation: 8, // Slight glow effect
                      shadowColor: Colors.blueAccent.withOpacity(0.5),
                      side: BorderSide(
                        color: Colors.white70, // Softer border color
                        width: 1.5, // Slightly thinner border
                      ),
                    ),
                    onPressed: () {
                      context.go('/login');
                    },
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 14, // Smaller font size
                        fontWeight: FontWeight.w500, // Medium font weight
                      ),
                    ),
                  ),
                ),
              ),


              const SizedBox(height: 70)



            ],
          ),
        ],
      ),
    );
  }
}