import 'package:farm_link_ai/ui/Customer/about/page.dart';
import 'package:farm_link_ai/ui/Customer/assistant/page.dart';
import 'package:farm_link_ai/ui/Customer/contact/page.dart';
import 'package:farm_link_ai/ui/Customer/home/page.dart';
import 'package:farm_link_ai/ui/Customer/order/page.dart';
import 'package:farm_link_ai/ui/Customer/payment/payment_screen.dart';
import 'package:farm_link_ai/ui/Customer/product/page.dart';
import 'package:farm_link_ai/ui/Farmer/DetectCrop/page.dart';
import 'package:farm_link_ai/ui/Farmer/ManageOrder/page.dart';
import 'package:farm_link_ai/ui/Farmer/ManageProduct/page.dart';
import 'package:farm_link_ai/ui/Farmer/RecommendCrop/page.dart';
import 'package:farm_link_ai/ui/Farmer/RecommendFertilizer/page.dart';
import 'package:farm_link_ai/ui/Farmer/dashboard/page.dart';
import 'package:farm_link_ai/ui/SplashScreen/page.dart';
import 'package:farm_link_ai/ui/login/page.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';


final GoRouter router = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [
    // Main entry route
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) => const SplashScreen(),
      routes: [
        GoRoute(
          path: 'login',
          builder: (BuildContext context, GoRouterState state) => const Login(),
        ),
        // Customer parent route
        GoRoute(
          path: 'customer',
          builder: (BuildContext context, GoRouterState state) => const Home(), // Default view for 'customer'
          routes: [
            GoRoute(
              path: 'about',
              builder: (BuildContext context, GoRouterState state) => const About(),
            ),
            GoRoute(
              path: 'contact',
              builder: (BuildContext context, GoRouterState state) => const Contact(),
            ),
            GoRoute(
              path: 'product',
              builder: (BuildContext context, GoRouterState state) =>  BookingPage(),
            ),
            GoRoute(
              path: 'order',
              builder: (BuildContext context, GoRouterState state) => const CustomerOrder(),
            ),
            GoRoute(
              path: 'payment',
              builder: (BuildContext context, GoRouterState state) =>  LanguageTogglePage(),
            ),
            GoRoute(
              path: 'assistant',
              builder: (BuildContext context, GoRouterState state) => ChatApp(),
            ),

          ],
        ),
        // Farmer parent route
        GoRoute(
          path: 'farmer',
          builder: (BuildContext context, GoRouterState state) => const Dashboard(), // Default view for 'farmer'
          routes: [
            GoRoute(
              path: 'product',
              builder: (BuildContext context, GoRouterState state) => const ManageProduct(),
            ),
            GoRoute(
              path: 'order',
              builder: (BuildContext context, GoRouterState state) => const ManageOrder(),
            ),
            // GoRoute(
            //   path: 'recommend-crop',
            //   builder: (BuildContext context, GoRouterState state) => const RecommendCrop(),
            // ),
            // GoRoute(
            //   path: 'recommend-fertilizer',
            //   builder: (BuildContext context, GoRouterState state) => const RecommendFertilizer(),
            // ),
            // GoRoute(
            //   path: 'detect-crop',
            //   builder: (BuildContext context, GoRouterState state) => const DetectCrop(),
            // ),

          ],
        ),
      ],
    ),
  ],
);
