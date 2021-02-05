import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naext/api/naext_api.dart';


class TText extends Text {
  TText(String data, BuildContext context, {
  Key key,
  style,
  strutStyle,
  textAlign,
  textDirection,
  locale,
  softWrap,
  overflow,
  textScaleFactor,
  maxLines,
  semanticsLabel,
  textWidthBasis,
  textHeightBehavior,
}) : super(Lang.has(context, data) ? Lang.get(context, data) : "NOT FOUND: $data", key: key, style: style, strutStyle: strutStyle, textAlign: textAlign, textDirection: textDirection, locale: locale, softWrap: softWrap, overflow: overflow,
  textScaleFactor: textScaleFactor, maxLines: maxLines, semanticsLabel: semanticsLabel, textWidthBasis: textWidthBasis, textHeightBehavior: textHeightBehavior);

}

class Lang {
  final Locale locale;

  Lang(this.locale);

  static String interpolate(String string, List<Object> params) {

    String result = string;
    for (int i = 1; i < params.length + 1; i++) {
      result = result.replaceAll('%$i\$', params[i-1].toString());
    }
    return result;
  }

  /*
  static const needleRegex = '(%\d)';
  static const needle = '(%\d)';
  static final RegExp exp = new RegExp(needleRegex);

  static String interpolate(String string, List l) {
    Iterable<RegExpMatch> matches = exp.allMatches(string);
    print(l.length.toString() + " | " + matches.length.toString());
    print(string + " - " + l.toString() + " | " + matches.toString());
    assert(l.length == matches.length);

    var i = -1;
    return string.replaceAllMapped(exp, (match) {
      print(match.group(0));1
      i = i + 1;
      return '${l[i]}';1
    });
  }*/

  // Helper method to keep the code in the widgets concise
  // Localizations are accessed using an InheritedWidget "of" syntax
  static Lang of(BuildContext context) {
    return Localizations.of<Lang>(context, Lang);
  }



  /*Locale get appLocal => _appLocale ?? Locale("en");
  fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString('language_code') == null) {
      _appLocale = Locale('en');
      return Null;
    }
    _appLocale = Locale(prefs.getString('language_code'));
    return Null;
  }*/

  // Static member to have a simple access to the delegate from the MaterialApp
  static const LocalizationsDelegate<Lang> delegate = _AppLocalizationsDelegate();

  Map<String, String> _localizedStrings;
  static Map<String, String> _langFiles = {
    "de" : "de.csv",
    "en" : "en.csv"
  };



  Future<Lang> loadCsv(locale) async {
    // Load the language JSON file from the "lang" folder
    Map<String, String> _langMappings = {};
    String path = "assets/lang/${locale.languageCode}.csv";
    print(locale.languageCode);
    String fileContent = await rootBundle.loadString(path);
    LineSplitter ls = new LineSplitter();
    List<String> lines = ls.convert(fileContent);
    int line = 0;
    lines.forEach((l) {
      line++;
      if(l != "") {
        var split = l.split(";");
        if(split.length != 2)
          throw new LanguageParserException("Row in language file ${locale.languageCode}.csv is invalid: '$l' in line #$line");
        if(split[0].length != 0 && split[1].length != 0)
          _langMappings[split[0]] = split[1];
      }


    });
    _localizedStrings = _langMappings;
    return Lang(locale);
  }

  // This method will be called from every widget which needs a localized text
  String getTranslatedText(String key) {
    assert(_localizedStrings.containsKey(key), "Key $key not found in translation");
    return _localizedStrings[key];
  }

  static String get(BuildContext context, String key) {
    return of(context).getTranslatedText(key);
  }

  static bool has(BuildContext context, String key) {
    return of(context)._localizedStrings.containsKey(key);
  }

}

// LocalizationsDelegate is a factory for a set of localized resources
// In this case, the localized strings will be gotten in an AppLocalizations object
class _AppLocalizationsDelegate extends LocalizationsDelegate<Lang> {
  // This delegate instance will never change (it doesn't even have fields!)
  // It can provide a constant constructor.

  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Include all of your supported language codes here
    return ['en', 'de'].contains(locale.languageCode);
  }

  @override
  Future<Lang> load(Locale locale) async {
    // AppLocalizations class is where the JSON loading actually runs
    Lang localizations = new Lang(locale);
    await localizations.loadCsv(locale);
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => true;
}

class LanguageParserException implements Exception {

  String message;

  LanguageParserException(this.message);

  @override
  String toString() {
    return 'LanguageParserException with message: $message}';
  }
}