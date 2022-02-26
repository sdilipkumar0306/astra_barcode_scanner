import 'package:astra_bar_code_scanner/pages/modal/bar_code_modal.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'dart:io';

class BarCodeService {
  Future<void> createExcel(BarCodes barInfo, BuildContext context) async {
    String fileName = "${barInfo.dcNo}_${DateTime.now().hour}_${DateTime.now().minute}_${DateTime.now().second}.xlsx";
    double totalWeight = 0.0;
    int totalBoxes = 0;
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
// seting Dc No
    sheet.getRangeByIndex(2, 1).setText("DC No");
    sheet.getRangeByIndex(2, 3).setText(barInfo.dcNo);
    sheet.getRangeByIndex(2, 1, 2, 2).merge();
    sheet.getRangeByIndex(2, 3, 2, 4).merge();

    int initialColum = 1;
    for (var i = 0; i < barInfo.classes.length; i++) {
      sheet
          .getRangeByIndex(7, initialColum)
          .setText("${barInfo.classes.elementAt(i).className} - ${barInfo.classes.elementAt(i).version} - ${barInfo.classes.elementAt(i).count}");
      final heading = sheet.getRangeByIndex(7, initialColum, 7, initialColum + 2);
      heading.merge();
      heading.cellStyle.hAlign = HAlignType.center;
      heading.cellStyle.fontSize = 12;
      heading.cellStyle.bold = true;
      heading.cellStyle.fontColor = '#f6f7f7';
      heading.cellStyle.backColor = '#ACB9CA';
      // sheet.getRangeByIndex(7, initialColum + 1, 7, initialColum + 2).merge();
      sheet.getRangeByIndex(8, initialColum).setText("Box No");
      sheet.getRangeByIndex(8, initialColum + 1).setText("Bar Code");
      sheet.getRangeByIndex(8, initialColum + 2).setText("Weight (Kg)");
      final subHeading = sheet.getRangeByIndex(8, initialColum, 8, initialColum + 2);
      subHeading.cellStyle.fontSize = 10;
      subHeading.cellStyle.bold = true;
      int nextRow = 0;
      for (var j = 0; j < barInfo.classes.elementAt(i).boxes.length; j++) {
        sheet.getRangeByIndex((8 + j + 1), initialColum).setNumber(barInfo.classes.elementAt(i).boxes.elementAt(j).boxNumber.toDouble());
        sheet.getRangeByIndex((8 + j + 1), initialColum + 1).setText(barInfo.classes.elementAt(i).boxes.elementAt(j).barCode);
        sheet.getRangeByIndex((8 + j + 1), initialColum + 2).setNumber(barInfo.classes.elementAt(i).boxes.elementAt(j).weight);
        totalWeight += barInfo.classes.elementAt(i).boxes.elementAt(j).weight;
        totalBoxes = barInfo.classes.elementAt(i).boxes.elementAt(j).boxNumber;
        final boxStyle = sheet.getRangeByIndex((8 + j + 1), initialColum);
        // boxStyle.cellStyle.fontColor = '#f6f7f7';
        boxStyle.cellStyle.backColor = '#c5d9ed';
        nextRow = (8 + j + 1);
      }
      for (var j = 0; j < barInfo.classes.elementAt(i).sets.length; j++) {
        sheet.getRangeByIndex((nextRow + j + 1), initialColum).setNumber(barInfo.classes.elementAt(i).sets.elementAt(j).boxNumber.toDouble());
        sheet.getRangeByIndex((nextRow + j + 1), initialColum + 1).setText(barInfo.classes.elementAt(i).sets.elementAt(j).barCode);
        sheet.getRangeByIndex((nextRow + j + 1), initialColum + 2).setNumber(barInfo.classes.elementAt(i).sets.elementAt(j).weight);
        totalWeight += barInfo.classes.elementAt(i).sets.elementAt(j).weight;
        final setsStyle = sheet.getRangeByIndex((nextRow + j + 1), initialColum);
        // setsStyle.cellStyle.fontColor = '#f6f7f7';
        setsStyle.cellStyle.backColor = '#f5e6ab';
      }

      initialColum += 4;
    }

    // setting total Boxes
    sheet.getRangeByIndex(3, 1).setText("Total Box");
    sheet.getRangeByIndex(3, 3).setNumber(totalBoxes.toDouble());
    sheet.getRangeByIndex(3, 1, 3, 2).merge();
    sheet.getRangeByIndex(3, 3, 3, 4).merge();

    // setting total weight
    sheet.getRangeByIndex(4, 1).setText("Total Weight (Kg)");
    sheet.getRangeByIndex(4, 3).setNumber(totalWeight);
    sheet.getRangeByIndex(4, 1, 4, 2).merge();
    sheet.getRangeByIndex(4, 3, 4, 4).merge();

    final mainContent = sheet.getRangeByIndex(2, 1, 4, 2);
    mainContent.cellStyle.fontSize = 12;
    mainContent.cellStyle.bold = true;

    final mainContentValues = sheet.getRangeByIndex(2, 3, 4, 4);

    mainContentValues.cellStyle.hAlign = HAlignType.center;
    mainContentValues.cellStyle.fontSize = 12;

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    String fileLocation = "/storage/emulated/0/Download/$fileName";
    final File file = File(fileLocation);
    bool isExist = await file.exists();
    if (!isExist) {
      await file.create();
    }
    await file.writeAsBytes(bytes, flush: true);
    SnackBar snackBar = SnackBar(
      content: Text("Downloaded as $fileName"),
      action: SnackBarAction(
          label: "Open",
          onPressed: () {
            OpenFile.open(fileLocation);
          }),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
