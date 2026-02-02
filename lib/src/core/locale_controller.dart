import 'package:flutter/material.dart';

class LocaleController extends ChangeNotifier {
  Locale _locale = Locale('en');

  Locale get locale => _locale;

  Future<void> changeLocale(String code) async {
    _locale = Locale(code);

    notifyListeners();
  }
}
