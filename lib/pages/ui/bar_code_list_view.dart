import 'package:astra_bar_code_scanner/pages/modal/basic_info_modal.dart';
import 'package:astra_bar_code_scanner/pages/modal/static_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../modal/bar_code_modal.dart';

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
  TextEditingController weightController = TextEditingController();
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
        title:
            Text("${barInfo.dcNo} - ${barInfo.classes.elementAt(widget.selectedIndex).className} - ${barInfo.classes.elementAt(widget.selectedIndex).count}"),
      ),
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Expanded(
                    child: ListView(
                  children: [
                    Column(
                      children: List.generate(barInfo.classes.elementAt(widget.selectedIndex).boxes.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                          child: ListTile(
                            minLeadingWidth: 10,
                            leading: Text("B-${barInfo.classes.elementAt(widget.selectedIndex).boxes.elementAt(index).boxNumber}.",
                                style: const TextStyle(fontSize: 20)),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  barInfo.classes.elementAt(widget.selectedIndex).boxes.elementAt(index).barCode,
                                  style: const TextStyle(fontSize: 18),
                                ),
                                Text(
                                  "${barInfo.classes.elementAt(widget.selectedIndex).boxes.elementAt(index).weight} Kg",
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                                onPressed: () async {
                                  reArangeBoxOrder(barInfo.classes.elementAt(widget.selectedIndex).boxes.elementAt(index).boxNumber);
                                  barInfo.classes.elementAt(widget.selectedIndex).boxes.removeAt(index);
                                  if (!mounted) return;
                                  setState(() {});
                                  StaticInfo.saveData(barInfo);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )),
                          ),
                        );
                      }),
                    ),
                    Column(
                      children: List.generate(barInfo.classes.elementAt(widget.selectedIndex).sets.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                          child: ListTile(
                            minLeadingWidth: 10,
                            leading: Text("S-${barInfo.classes.elementAt(widget.selectedIndex).sets.elementAt(index).boxNumber}.",
                                style: const TextStyle(fontSize: 20)),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  barInfo.classes.elementAt(widget.selectedIndex).sets.elementAt(index).barCode,
                                  style: const TextStyle(fontSize: 18),
                                ),
                                Text(
                                  "${barInfo.classes.elementAt(widget.selectedIndex).sets.elementAt(index).weight} Kg",
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                                onPressed: () async {
                                  reArangeSetsOrder(barInfo.classes.elementAt(widget.selectedIndex).sets.elementAt(index).boxNumber);
                                  barInfo.classes.elementAt(widget.selectedIndex).sets.removeAt(index);

                                  if (!mounted) return;
                                  setState(() {});
                                  StaticInfo.saveData(barInfo);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )),
                          ),
                        );
                      }),
                    ),
                  ],
                )),
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
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
              ],
            ),
          )
        ],
      ),
    );
  }

  void reArangeBoxOrder(int removedCount) {
    for (var i = 0; i < barInfo.classes.length; i++) {
      for (var j = 0; j < barInfo.classes.elementAt(i).boxes.length; j++) {
        if (barInfo.classes.elementAt(i).boxes.elementAt(j).boxNumber > removedCount) {
          barInfo.classes.elementAt(i).boxes.elementAt(j).boxNumber -= 1;
        }
      }
    }
    StaticInfo.boxCount -= 1;
  }

  void reArangeSetsOrder(int removedCount) {
    for (var i = 0; i < barInfo.classes.length; i++) {
      for (var j = 0; j < barInfo.classes.elementAt(i).sets.length; j++) {
        if (barInfo.classes.elementAt(i).sets.elementAt(j).boxNumber > removedCount) {
          barInfo.classes.elementAt(i).sets.elementAt(j).boxNumber -= 1;
        }
      }
    }
    StaticInfo.setsCount -= 1;
  }

  Future<void> getTextField() async {
    bool isBox = true;
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Enter BarCode"),
        content: StatefulBuilder(builder: (BuildContext context, state) {
          return SizedBox(
            width: 400,
            height: 250,
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Sets",
                        style: isBox ? null : const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                      Switch(
                        onChanged: (isOn) {
                          isBox = isOn;
                          state(() {});
                        },
                        value: isBox,
                      ),
                      Text(
                        "Box",
                        style: !isBox ? null : const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isBox ? const Text("Box No : ") : const Text("Set No : "),
                      isBox ? Text(StaticInfo.boxCount.toString()) : Text(StaticInfo.setsCount.toString())
                    ],
                  ),
                ),
                SizedBox(
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: barCodeController,
                      decoration: InputDecoration(
                          hintText: "Enter BarCode",
                          labelText: "Bar Code",
                          suffixIcon: Container(
                            decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor),
                            child: IconButton(
                                onPressed: () async {
                                  String respose = await scanBarcodeNormal();
                                  if (respose != "-1") {
                                    barCodeController.text = respose;
                                    state(() {});
                                  }
                                },
                                icon: const Icon(
                                  Icons.qr_code_scanner_sharp,
                                  color: Colors.white,
                                )),
                          )),
                    ),
                  ),
                ),
                SizedBox(
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: weightController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r"^\d*\.?\d*"))],
                      decoration: const InputDecoration(hintText: "Enter Weight", labelText: "Weight", suffixText: "Kg"),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text("No"),
          ),
          ElevatedButton(
            onPressed: () {
              if (barCodeController.text.trim().isNotEmpty && weightController.text.trim().isNotEmpty) {
                if (isBox) {
                  Boxes res = Boxes(barCode: barCodeController.text, boxNumber: StaticInfo.boxCount, weight: double.parse(weightController.text.trim()));
                  barInfo.classes.elementAt(widget.selectedIndex).boxes.add(res);
                  StaticInfo.boxCount++;
                } else {
                  Boxes res = Boxes(barCode: barCodeController.text, boxNumber: StaticInfo.setsCount, weight: double.parse(weightController.text.trim()));
                  barInfo.classes.elementAt(widget.selectedIndex).sets.add(res);
                  StaticInfo.setsCount++;
                }
                barCodeController.clear();
                weightController.clear();
                StaticInfo.saveData(barInfo);
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

  Future<String> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return "-1";

    if (barInfo.classes.elementAt(widget.selectedIndex).boxes.map((e) => e.barCode).toList().contains(barcodeScanRes)) {
      return "-1";
    } else {
      return barcodeScanRes;
    }
  }
}
