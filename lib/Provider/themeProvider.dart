import 'package:flutter/material.dart';
import 'package:flutter_chat/Common/staticMembers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  SharedPreferences sharedPreferences;
  int lightMode = THEMEMODE.LIGHT;
  int selColor = THEMECOLORMAPPING.BLUEGREY;
  Color themeColor = THEMECOLOR.BLUEGREY;
  ThemeProvider(SharedPreferences sp) {
    sharedPreferences = sp;
    if (sp.containsKey("dark")) {
      lightMode = sp.getInt("darks");
    }
    if (sp.containsKey("color")) {
      selColor = sp.getInt("color");
      themeColor = getThemeColorFromPrefs(selColor);
    }
  }
  changeSelColor(int index) {
    themeColor = getThemeColorFromPrefs(index);
    sharedPreferences.setInt('color', index);
    notifyListeners();
  }

  Color getThemeColorFromPrefs(int chooseColor) {
    // var chooseColor = pref.getInt('color');
    Color result;
    switch (chooseColor) {
      case THEMECOLORMAPPING.BLUEGREY:
        result = THEMECOLOR.BLUEGREY;
        break;
      case THEMECOLORMAPPING.YELLOW:
        result = THEMECOLOR.YELLOW;
        break;
      case THEMECOLORMAPPING.PURPLE:
        result = THEMECOLOR.PURPLE;
        break;
      case THEMECOLORMAPPING.RED:
        result = THEMECOLOR.RED;
        break;
      default:
        result = THEMECOLOR.BLUEGREY;
        break;
    }
    return result;
  }
}
