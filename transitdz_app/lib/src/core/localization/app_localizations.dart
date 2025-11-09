import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class AppLocalizations {
  AppLocalizations(this.locale, this._localizedStrings);

  final Locale locale;
  final Map<String, dynamic> _localizedStrings;

  static const supportedLocales = [
    Locale('en'),
    Locale('fr'),
    Locale('ar'),
  ];

  static const supportedLanguageCodes = ['en', 'fr', 'ar'];

  static Future<AppLocalizations> load(Locale locale) async {
    final languageCode = supportedLanguageCodes.contains(locale.languageCode)
        ? locale.languageCode
        : 'en';
    final jsonString =
        await rootBundle.loadString('assets/translations/$languageCode.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return AppLocalizations(locale, jsonMap);
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  String translate(String key, {Map<String, String>? params}) {
    final keys = key.split('.');
    dynamic current = _localizedStrings;
    for (final part in keys) {
      if (current is Map<String, dynamic> && current.containsKey(part)) {
        current = current[part];
      } else {
        return key;
      }
    }
    var value = current?.toString() ?? key;
    params?.forEach((placeholder, replacement) {
      value = value.replaceAll('{$placeholder}', replacement);
    });
    return value;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLanguageCodes.contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) =>
      AppLocalizations.load(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}
