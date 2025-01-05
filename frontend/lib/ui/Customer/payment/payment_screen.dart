import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageTogglePage extends StatelessWidget {
  const LanguageTogglePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('language_toggle'.tr()), // Use a translation key
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'welcome_message'.tr(), // Translated text
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Toggle language
                if (context.locale == const Locale('en', 'US')) {
                  context.setLocale(const Locale('kn', 'IN'));
                } else {
                  context.setLocale(const Locale('en', 'US'));
                }
              },
              child: Text('toggle_language'.tr()), // Button label
            ),
          ],
        ),
      ),
    );
  }
}
