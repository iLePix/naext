import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naext/application.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_localizations.dart';


// ignore: must_be_immutable
class NaextApp extends StatefulWidget {

  static void setLocale(BuildContext context, Locale locale) {
    _NaextAppState state = context.findAncestorStateOfType<_NaextAppState>();
    state.setLocale(locale);
  }

  @override
  _NaextAppState createState() => _NaextAppState();
}

class _NaextAppState extends State<NaextApp> {
  Locale _locale;
  FirebaseAnalytics analytics = FirebaseAnalytics();

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'YourEco',
      theme: ThemeData(
      ),
      locale: _locale,
      supportedLocales: [
        Locale('en', ''),
        Locale('de', ''),
      ],
      // These delegates make sure that the localization data for the proper language is loaded
      localizationsDelegates: [
        // A class which loads the translations from JSON files
        Lang.delegate,
        // Built-in localization of basic text for Material widgets
        GlobalMaterialLocalizations.delegate,
        // Built-in localization for text direction LTR/RTL
        GlobalWidgetsLocalizations.delegate,
      ],
      // Returns a locale which will be used by the app
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is supported
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode) {  //ceheck if supportedLocale.countryCode == locale.countryCode
            return supportedLocale;
          }
        }
        // If the locale of the device is not supported, use the first one
        // from the list (English, in this case).
        return supportedLocales.first;
      },
      home: Application(),
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
    );
  }
}
