import 'dart:convert';

import 'package:astra_bar_code_scanner/pages/modal/bar_code_modal.dart';
import 'package:astra_bar_code_scanner/pages/ui/bar_code_list_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service.dart';
import 'home_page.dart';

class ClassesList extends StatefulWidget {
  final BarCodes astraBarCode;
  const ClassesList({Key? key, required this.astraBarCode}) : super(key: key);

  @override
  _ClassesListState createState() => _ClassesListState();
}

class _ClassesListState extends State<ClassesList> {
  BarCodeService service = BarCodeService();
  late BarCodes astraBarCode;
  @override
  void initState() {
    astraBarCode = widget.astraBarCode;
    super.initState();
  }

  int? selected; //attention

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
            icon: const Icon(Icons.logout_rounded)),
        centerTitle: true,
        title: Text(astraBarCode.dcNo),
        actions: [
          IconButton(
              onPressed: () {
                service.createExcel(astraBarCode, context);
              },
              icon: const Icon(Icons.download))
        ],
      ),
      body: ListView.builder(
        key: Key('builder ${selected.toString()}'),
        itemCount: astraBarCode.classes.length,
        itemBuilder: (context, i) {
          return ExpansionTile(
            key: Key(i.toString()),
            initiallyExpanded: i == selected,
            title: Text(astraBarCode.classes.elementAt(i).className),
            children: productExpandAbleListBuilder(i),
            onExpansionChanged: ((newState) {
              if (newState) {
                setState(() {
                  selected = i;
                });
              } else {
                setState(() {
                  selected = -1;
                });
              }
            }),
            leading: Container(
              color: Colors.cyan,
              width: 50,
              height: 40,
              child: IconButton(
                splashRadius: 10,
                onPressed: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (context) => BarCodesListview(astraBarCode: astraBarCode, selectedIndex: i)));
                  SharedPreferences pref = await SharedPreferences.getInstance();
                  dynamic data = pref.getString("ASTRA_BAR_INFO");
                  astraBarCode = BarCodes.parseResponse(jsonDecode(data));
                  setState(() {});
                },
                icon: const Icon(Icons.add),
              ),
            ),
          );
        },
      ),
    );
  }

  productExpandAbleListBuilder(int index) {
    List<Widget> columnContent = List.generate(
      astraBarCode.classes.elementAt(index).boxes.length,
      (subIndex) => Container(
        margin: const EdgeInsets.only(left: 30),
        child: ListTile(
          title: Text(astraBarCode.classes.elementAt(index).boxes.elementAt(subIndex).barCode),
          leading: Text("${subIndex + 1}"),
        ),
      ),
    );
    columnContent.addAll(List.generate(
      astraBarCode.classes.elementAt(index).sets.length,
      (subIndex) => Container(
        margin: const EdgeInsets.only(left: 30),
        child: ListTile(
          title: Text(astraBarCode.classes.elementAt(index).sets.elementAt(subIndex).barCode),
          leading: Text("${subIndex + 1}"),
        ),
      ),
    ));

    return columnContent;
  }
}
