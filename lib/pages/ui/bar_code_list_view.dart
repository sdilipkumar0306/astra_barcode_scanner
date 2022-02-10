import 'dart:convert';
import 'dart:io';

import 'package:astra_bar_code_scanner/pages/modal/basic_info_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'home_page.dart';

class BarCodesListview extends StatefulWidget {
  final AstraBarCodeInfo barInfo;
  const BarCodesListview({Key? key, required this.barInfo}) : super(key: key);

  @override
  _BarCodesListviewState createState() => _BarCodesListviewState();
}

class _BarCodesListviewState extends State<BarCodesListview> {
  late AstraBarCodeInfo barInfo;
  @override
  void initState() {
    barInfo = widget.barInfo;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () async {
              SharedPreferences pref = await SharedPreferences.getInstance();
              pref.clear();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
            },
            icon: const Icon(Icons.logout)),
        actions: [
          IconButton(
              onPressed: barInfo.barCode.isEmpty
                  ? null
                  : () {
                      createExcel();
                    },
              icon: const Icon(Icons.download))
        ],
        centerTitle: true,
        title: Text("${barInfo.schoolDcNo} - ${barInfo.className} - ${barInfo.setsCount}"),
      ),
      body: ListView.builder(
        itemCount: barInfo.barCode.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
            child: ListTile(
              minLeadingWidth: 10,
              leading: Text("${(index + 1)}.", style: const TextStyle(fontSize: 20)),
              title: Text(
                barInfo.barCode.elementAt(index),
                style: const TextStyle(fontSize: 18),
              ),
              trailing: IconButton(
                  onPressed: () async {
                    barInfo.barCode.removeAt(index);
                    if (!mounted) return;
                    setState(() {});
                    SharedPreferences pref = await SharedPreferences.getInstance();
                    pref.setString("ASTRA_BAR_INFO", jsonEncode(barInfo.getMap()));
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  )),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await scanBarcodeNormal();
        },
      ),
    );
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    if (barInfo.barCode.contains(barcodeScanRes)) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Alert"),
          content: Text("$barcodeScanRes Already contains in list do you want to add again"),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text("No"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  barInfo.barCode.add(barcodeScanRes);
                });
                Navigator.of(ctx).pop();
              },
              child: const Text("add"),
            ),
          ],
        ),
      );
    } else {
      setState(() {
        barInfo.barCode.add(barcodeScanRes);
      });
    }

    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("ASTRA_BAR_INFO", jsonEncode(barInfo.getMap()));
  }

  Future<void> createExcel() async {
    String fileName =
        "${widget.barInfo.schoolDcNo}_${widget.barInfo.className}_${widget.barInfo.setsCount}_${DateTime.now().minute}_${DateTime.now().second}.xlsx";

    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    for (var i = 0; i < barInfo.barCode.length; i++) {
      sheet.getRangeByName('A${i + 1}').setText(barInfo.barCode.elementAt(i));
    }
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    // final String path = (await getApplicationSupportDirectory()).path;

    final File file = File("/storage/emulated/0/Download/$fileName");
    bool isExist = await file.exists();
    if (!isExist) {
      await file.create();
    }
    await file.writeAsBytes(bytes, flush: true);
    SnackBar snackBar = SnackBar(
      content: Text("Downloaded as $fileName"),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
