import 'dart:convert';

import 'package:astra_bar_code_scanner/pages/modal/bar_code_modal.dart';
import 'package:astra_bar_code_scanner/pages/ui/classes_list.dart';
import 'package:astra_bar_code_scanner/pages/ui/home_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getdata(context);
    return const Scaffold(
      body: Center(
        child: SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Future<void> getdata(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    dynamic data = pref.getString("ASTRA_BAR_INFO");
    if (data == null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
    } else {
      BarCodes astraBarCode = BarCodes.parseResponse(jsonDecode(data));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClassesList(astraBarCode: astraBarCode)));
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BarCodesListview(barInfo: info)));
    }

    //  AstraBarCodeInfo data
  }
}
