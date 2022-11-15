import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../themes/theme.dart';

class PreferencesProvider extends ChangeNotifier {

  ThemeData currentTheme;
  bool _isDarkmode=false;

  final storage = const FlutterSecureStorage();

  PreferencesProvider({
    required bool isDarkmode
  }): currentTheme = isDarkmode ? ThemeData.dark() : themeLight;

  setLightMode(){
    currentTheme = ThemeData.light();
    notifyListeners();
  }

  setDarkmode(){
    currentTheme = ThemeData.dark();
    notifyListeners();
  }

  bool get isDarkmode => _isDarkmode;

  set isDarkmode(bool value){
    _isDarkmode=value;
    storage.write(key: 'isDarkmode', value: value.toString());
    notifyListeners();
  }

}