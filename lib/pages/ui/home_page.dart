import 'dart:convert';

import 'package:astra_bar_code_scanner/pages/modal/basic_info_modal.dart';
import 'package:astra_bar_code_scanner/pages/ui/bar_code_list_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController schoolDcNo = TextEditingController();
  TextEditingController className = TextEditingController();
  TextEditingController totalCount = TextEditingController();

  String? schoolDcNoerror;
  String? _classNameerror;
  String? totalCounterror;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Container(
                margin: const EdgeInsets.all(10),
                width: 500,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        "Astra Qr Scanner",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: schoolDcNo,
                        decoration: InputDecoration(
                          labelText: 'DC No',
                          hintText: 'Enter DC No',
                          errorText: schoolDcNoerror,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: className,
                        decoration: InputDecoration(
                          labelText: 'Class Name',
                          hintText: 'Enter Class Name',
                          errorText: _classNameerror,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: totalCount,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Sets',
                          hintText: 'Enter Sets',
                          errorText: totalCounterror,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Container(
                      width: 80,
                      height: 40,
                      margin: const EdgeInsets.all(15),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (schoolDcNo.text.trim().isEmpty) {
                            schoolDcNoerror = "Enter School DC No";
                          } else if (className.text.trim().isEmpty) {
                            schoolDcNoerror = null;

                            _classNameerror = "Enter Class Name";
                          } else if (totalCount.text.trim().isEmpty) {
                            schoolDcNoerror = null;
                            _classNameerror = null;
                            totalCounterror = "Enter No of Book Sets";
                          } else {
                            schoolDcNoerror = null;
                            _classNameerror = null;
                            totalCounterror = null;
                            int lcTotalCount = int.parse(totalCount.text);

                            AstraBarCodeInfo data = AstraBarCodeInfo(
                              schoolDcNo: schoolDcNo.text,
                              className: className.text,
                              setsCount: lcTotalCount,
                              barCode: List<String>.empty(growable: true),
                            );
                            if (!mounted) return;
                            setState(() {});

                            SharedPreferences pref = await SharedPreferences.getInstance();
                            pref.setString("ASTRA_BAR_INFO", jsonEncode(data.getMap()));
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BarCodesListview(barInfo: data)));
                          }
                          if (!mounted) return;
                          setState(() {});
                        },
                        child: const Text("Next"),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
