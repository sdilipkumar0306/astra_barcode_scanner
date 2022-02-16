import 'dart:convert';

import 'package:astra_bar_code_scanner/pages/modal/bar_code_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StaticInfo {
  static int boxCount = 1;
  static int setsCount = 1;

  static Future<void> saveData(BarCodes barInfo) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("ASTRA_BAR_INFO", jsonEncode(barInfo.getMap()));
    pref.setInt("BOX_COUNT", StaticInfo.boxCount);
    pref.setInt("SETS_COUNT", StaticInfo.setsCount);
  }

  static Future<BarCodes?> getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    dynamic data = pref.getString("ASTRA_BAR_INFO");
    StaticInfo.boxCount = pref.getInt("BOX_COUNT") ?? 1;
    StaticInfo.setsCount = pref.getInt("SETS_COUNT") ?? 1;
    if (data != null) {
      return BarCodes.parseResponse(jsonDecode(data));
    }
    return null;
  }

  static List<List<dynamic>> classesData() {
    List<dynamic> section1 = [
      [false, "Nursery"],
      [false, "L.K.G"],
      [false, "U.K.G"],
      [false, "Grade 1"],
      [false, "Grade 2"],
      [false, "Grade 3"],
      [false, "Grade 4"],
      [false, "Grade 5"],
    ];
    List<dynamic> section2 = [
      [false, "CS 1"],
      [false, "CS 2"],
      [false, "CS 3"],
      [false, "CS 4"],
      [false, "CS 5"],
      [false, "CS 6"],
      [false, "CS 7"],
      [false, "CS 8"],
      [false, "CS 9"],
      [false, "CS 10"],
    ];
    List<dynamic> section3 = [
      [false, "GK 1"],
      [false, "GK 2"],
      [false, "GK 3"],
      [false, "GK 4"],
      [false, "GK 5"],
    ];
    return [section1, section2, section3];
  }
}
