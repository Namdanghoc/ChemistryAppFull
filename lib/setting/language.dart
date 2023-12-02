import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  bool _isEnglish = true;

  bool get isEnglish => _isEnglish;

  LanguageProvider() {
    _loadLanguage();
  }

  void _loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isEnglish = prefs.getBool('isEnglish') ?? true;
    notifyListeners();
  }

  void _saveLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isEnglish', _isEnglish);
  }

  void toggleLanguage() {
    _isEnglish = !_isEnglish;
    _saveLanguage();
    notifyListeners();
  }
}
