import 'dart:convert';
import 'package:astra_bar_code_scanner/pages/modal/basic_info_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../modal/bar_code_modal.dart';
import 'home_page.dart';

class BarCodesListview extends StatefulWidget {
  final BarCodes astraBarCode;
  final int selectedIndex;
  const BarCodesListview({Key? key, required this.astraBarCode, required this.selectedIndex}) : super(key: key);

  @override
  _BarCodesListviewState createState() => _BarCodesListviewState();
}

class _BarCodesListviewState extends State<BarCodesListview> {
  late BarCodes barInfo;
  TextEditingController barCodeController = TextEditingController();
  @override
  void initState() {
    barInfo = widget.astraBarCode;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () async {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
        centerTitle: true,
        title: Text("${barInfo.dcNo} - ${barInfo.classes.elementAt(widget.selectedIndex).className}"),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: barInfo.classes.elementAt(widget.selectedIndex).boxes.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                child: ListTile(
                  minLeadingWidth: 10,
                  leading: Text("${(index + 1)}.", style: const TextStyle(fontSize: 20)),
                  title: Text(
                    barInfo.classes.elementAt(widget.selectedIndex).boxes.elementAt(index).barCode,
                    style: const TextStyle(fontSize: 18),
                  ),
                  trailing: IconButton(
                      onPressed: () async {
                        barInfo.classes.elementAt(widget.selectedIndex).boxes.removeAt(index);
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
          Positioned(
            bottom: 10,
            right: 10,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                    heroTag: "ABC",
                    child: const Icon(Icons.text_fields),
                    onPressed: () async {
                      getTextField();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                    heroTag: "DEF",
                    child: const Icon(Icons.add),
                    onPressed: () async {
                      await scanBarcodeNormal();
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> getTextField() async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Enter BarCode"),
        content: SizedBox(
          width: 120,
          height: 50,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: barCodeController,
            ),
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text("No"),
          ),
          ElevatedButton(
            onPressed: () {
              if (barCodeController.text.trim().isNotEmpty) {
                barInfo.classes.elementAt(widget.selectedIndex).boxes.add(Boxes(barCode: barCodeController.text, boxNumber: 0, weight: 0));
                barCodeController.clear();
                saveData();
                Navigator.of(ctx).pop();
              }
            },
            child: const Text("add"),
          ),
        ],
      ),
    );
    setState(() {});
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;
    if (barcodeScanRes != "-1") {
      if (barInfo.classes.elementAt(widget.selectedIndex).boxes.map((e) => e.barCode).toList().contains(barcodeScanRes)) {
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
                    barInfo.classes.elementAt(widget.selectedIndex).boxes.add(Boxes(barCode: barCodeController.text, boxNumber: 0, weight: 0));
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
          barInfo.classes.elementAt(widget.selectedIndex).boxes.add(Boxes(barCode: barCodeController.text, boxNumber: 0, weight: 0));
        });
      }
    }

    saveData();
  }

  Future<void> saveData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("ASTRA_BAR_INFO", jsonEncode(barInfo.getMap()));
  }
}
