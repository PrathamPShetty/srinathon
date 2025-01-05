import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class HiveUtils {
  static const String _boxName = 'userBox';
  static const String _userTypeKey = 'userType';
  static const String _locale = 'locale';

  // Initialize Hive
  static Future<void> init() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      Hive.init(directory.path);
      await Hive.openBox(_boxName);
      debugPrint('Hive initialized and box $_boxName opened successfully');
    } catch (e) {
      debugPrint('Error initializing Hive: $e');
    }
  }

  // Delete all data
  static Future<void> deleteAll() async {
    try {
      if (Hive.isBoxOpen(_boxName)) {
        await Hive.box(_boxName).clear();
        await Hive.box(_boxName).close();
      }
      await Hive.deleteBoxFromDisk(_boxName);
      debugPrint('All data deleted and box $_boxName removed from disk');
    } catch (e) {
      debugPrint('Error deleting all data: $e');
    }
  }

  // Save user type
  static Future<void> saveUserType(bool isFarmer) async {
    try {
      var box = Hive.isBoxOpen(_boxName) ? Hive.box(_boxName) : await Hive.openBox(_boxName);
      await box.put(_userTypeKey, isFarmer); // `true` for farmer, `false` for customer
      debugPrint('User type saved as $isFarmer');
    } catch (e) {
      debugPrint('Error saving user type: $e');
    }
  }

  // Retrieve user type
  static Future<bool> getUserType() async {
    try {
      var box = Hive.isBoxOpen(_boxName) ? Hive.box(_boxName) : await Hive.openBox(_boxName);
      final userType = box.get(_userTypeKey, defaultValue: false);
      debugPrint('User type retrieved as $userType');
      return userType;
    } catch (e) {
      debugPrint('Error retrieving user type: $e');
      return false; // Default to false (customer) if an error occurs
    }
  }
  static Future<String> getLocale() async {
    try {
      var box = Hive.isBoxOpen(_boxName) ? Hive.box(_boxName) : await Hive.openBox(_boxName);
      final userType = box.get(_locale, defaultValue: 'en');
      return userType;
    } catch (e) {
      debugPrint('Error retrieving user type: $e');
      return 'kn'; // Default to false (customer) if an error occurs
    }
  }
  static Future<void> setLocale(String locale) async {
    try {
      var box = Hive.isBoxOpen(_boxName) ? Hive.box(_boxName) : await Hive.openBox(_boxName);
      await box.put(_locale, locale);
    } catch (e) {
      debugPrint('Error saving user type: $e');
    }
  }
}
