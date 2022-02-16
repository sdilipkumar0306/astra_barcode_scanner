import 'package:astra_bar_code_scanner/pages/modal/bar_code_modal.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'dart:io';

class BarCodeService {
  Future<void> createExcel(BarCodes barInfo, BuildContext context) async {
    // String fileName = "${barInfo.dcNo}_${DateTime.now().hour}_${DateTime.now().minute}_${DateTime.now().second}.xlsx";

    // final Workbook workbook = Workbook();
    // final Worksheet sheet = workbook.worksheets[0];
    // for (var i = 0; i < barInfo.classes.length; i++) {
    //   sheet.getRangeByName('A${i + 1}').setText(barInfo.classes.elementAt(i).className);
    // }
    // final List<int> bytes = workbook.saveAsStream();
    // workbook.dispose();

    // // final String path = (await getApplicationSupportDirectory()).path;

    // final File file = File("/storage/emulated/0/Download/$fileName");
    // bool isExist = await file.exists();
    // if (!isExist) {
    //   await file.create();
    // }
    // await file.writeAsBytes(bytes, flush: true);
    // SnackBar snackBar = SnackBar(
    //   content: Text("Downloaded as $fileName"),
    // );
    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
