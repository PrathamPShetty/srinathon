import 'package:farm_link_ai/utils/hive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart'; // Ensure this file provides necessary functionality
import 'core/router/router.dart';
import 'localization/app_locale.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveUtils.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalization _localization = FlutterLocalization.instance;

  @override
  void initState() {
    super.initState();
    _localization.init(
      mapLocales: [
        MapLocale('en', AppLocale.EN),
        MapLocale('kn', AppLocale.KN),
      ],
      initLanguageCode: 'kn', // Default language (Kannada)
    );
    debugPrint("This is a debug message");
    _localization.onTranslatedLanguage = _onTranslatedLanguage;
  }

  void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      supportedLocales: _localization.supportedLocales,
      localizationsDelegates: _localization.localizationsDelegates,
      locale: _localization.currentLocale,
      theme: ThemeData(
        fontFamily: _localization.currentLocale?.languageCode == 'kn'
            ? 'NotoSansKannada'  // Use the Kannada font for Kannada locale
            : null,  // Default font for other locales
      ),
    );
  }
}

class PermissionsScreen extends StatefulWidget {
  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  bool isCheckingPermissions = true;

  @override
  void initState() {
    super.initState();
    checkAndRequestPermissions();
  }

  Future<void> checkAndRequestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.storage,
      Permission.photos, // For iOS
    ].request();

    statuses.forEach((permission, status) {
      if (status.isDenied) {
        debugPrint('$permission permission denied.');
      } else if (status.isPermanentlyDenied) {
        debugPrint('$permission permission permanently denied. Open settings to grant.');
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
    return isCheckingPermissions
        ? PermissionsLoadingShimmer() // Show shimmer effect while checking permissions
        : Scaffold(
      appBar: AppBar(title: Text('Permissions Granted')),
      body: Center(child: Text('All permissions granted!')),
    );
  }
}

class PermissionsLoadingShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                height: 60.0,
                color: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }
}
