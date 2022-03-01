import 'package:astra_bar_code_scanner/pages/modal/bar_code_modal.dart';
import 'package:astra_bar_code_scanner/pages/modal/basic_info_modal.dart';
import 'package:astra_bar_code_scanner/pages/modal/static_info.dart';
import 'package:astra_bar_code_scanner/pages/ui/classes_list.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController schoolDcNo = TextEditingController();
  String? schoolDcNoerror;
  List<List<dynamic>> classInfo = List<List<dynamic>>.empty(growable: true);
  int? selected; //attention
  @override
  void initState() {
    classInfo = StaticInfo.classesData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              margin: EdgeInsets.only(top: 30),
              child: Container(
                margin: const EdgeInsets.all(10),
                width: 550,
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
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                    Expanded(
                      // height: (selected == null || selected == -1) ? 250 : 520,
                      child: ListView.builder(
                        key: Key('builder ${selected.toString()}'),
                        itemCount: classInfo.length,
                        itemBuilder: (context, i) {
                          return Container(
                            decoration: BoxDecoration(border: Border.all(color: Theme.of(context).primaryColor)),
                            margin: const EdgeInsets.all(8),
                            child: ExpansionTile(
                              key: Key(i.toString()),
                              initiallyExpanded: i == selected,
                              title: Text(i == 0
                                  ? "Nur - Grade 5"
                                  : i == 1
                                      ? "CS"
                                      : i == 2
                                          ? "GK"
                                          : "PC's"),
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
                            ),
                          );
                        },
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
                          } else {
                            schoolDcNoerror = null;
                            onNextClick();
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

  productExpandAbleListBuilder(int index) {
    List<Widget> columnContent = List.generate(
      classInfo.elementAt(index).length,
      (subIndex) => myCheckBox(index, subIndex),
    );

    return columnContent;
  }

  Widget myCheckBox(int mainIndex, int subindex) {
    return Row(
      children: <Widget>[
        const SizedBox(width: 10),
        Checkbox(
          value: classInfo.elementAt(mainIndex).elementAt(subindex)[0],
          onChanged: (bool? value) async {
            onCheckBoxClick(mainIndex, subindex);
          },
        ),
        const SizedBox(width: 10),
        InkWell(
          onTap: () {
            onCheckBoxClick(mainIndex, subindex);
          },
          child: Text(
            (classInfo[mainIndex][subindex][2] != 0)
                ? ("${classInfo[mainIndex][subindex][1]}   --   ${classInfo[mainIndex][subindex][2]}")
                : (classInfo[mainIndex][subindex][1]),
            style: const TextStyle(fontSize: 17.0),
          ),
        ),
      ],
    );
  }

  Future<void> onCheckBoxClick(int mainIndex, int subindex) async {
    int count = 0;
    int? versionIndex;
    int? aTcBIndex;
    TextEditingController countController = TextEditingController();
    if (!classInfo[mainIndex][subindex][0] == true) {
      await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              title: Center(child: Text("Enter Count for ${classInfo[mainIndex][subindex][1]}")),
              content: StatefulBuilder(builder: (BuildContext context, setState) {
                return Container(
                  width: 500,
                  height: 300,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 450,
                        height: 80,
                        child: TextFormField(
                          controller: countController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Count',
                            hintText: 'Enter Count',
                            errorText: schoolDcNoerror,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Versions :"),
                            SizedBox(
                              width: 500,
                              height: 60,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: List.generate(
                                    StaticInfo.versionList.length,
                                    (index) => Container(
                                        margin: const EdgeInsets.only(left: 6),
                                        width: 90,
                                        height: 40,
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: 1,
                                              groupValue: versionIndex == index ? 1 : -1,
                                              onChanged: (value) {
                                                setState(() {
                                                  versionIndex = index;
                                                });
                                              },
                                              activeColor: Colors.green,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child: Text(StaticInfo.versionList.elementAt(index)),
                                            )
                                          ],
                                        ))),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (mainIndex == 0 && (versionIndex == 2 || versionIndex == 3) && subindex != 0)
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Volumes :"),
                              SizedBox(
                                width: 500,
                                height: 60,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: List.generate(
                                      StaticInfo.aTcB.length,
                                      (index) => Container(
                                          margin: const EdgeInsets.only(left: 6),
                                          width: 120,
                                          height: 40,
                                          child: Row(
                                            children: [
                                              Radio(
                                                value: 1,
                                                groupValue: aTcBIndex == index ? 1 : -1,
                                                onChanged: (value) {
                                                  setState(() {
                                                    aTcBIndex = index;
                                                  });
                                                },
                                                activeColor: Colors.green,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(4.0),
                                                child: Text(StaticInfo.aTcB.elementAt(index)),
                                              )
                                            ],
                                          ))),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              }),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: () {
                      count = 0;
                      Navigator.of(context).pop();
                    },
                    child: const Text("Cancel"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (countController.text.trim().isNotEmpty && versionIndex != null) {
                        count = int.parse(countController.text);
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text("Ok"),
                  ),
                ),
              ],
            );
          });
    }
    if (count != 0) {
      setState(() {
        classInfo[mainIndex][subindex][0] = !classInfo[mainIndex][subindex][0];
        classInfo[mainIndex][subindex][2] = count;
        if (mainIndex == 0 && subindex == 0) {
          classInfo[mainIndex][subindex][3] = "${StaticInfo.versionList.elementAt(versionIndex!)} - C ";
        } else {
          classInfo[mainIndex][subindex][3] =
              "${StaticInfo.versionList.elementAt(versionIndex!)} ${aTcBIndex != null ? '- ${StaticInfo.aTcB.elementAt(aTcBIndex!).substring(0, 1)}' : ''} ";
        }
        classInfo[mainIndex][subindex][3] = classInfo[mainIndex][subindex][3].toString().trim();
      });
    }
  }

  void onNextClick() {
    List<ClassInfo> classes = List<ClassInfo>.empty(growable: true);
    for (var i in classInfo) {
      for (var j in i) {
        if (j[0]) {
          classes
              .add(ClassInfo(className: j[1], count: j[2], version: j[3], boxes: List<Boxes>.empty(growable: true), sets: List<Boxes>.empty(growable: true)));
        }
      }
    }
    BarCodes astraBarCode = BarCodes(dcNo: schoolDcNo.text, classes: classes);
    if (classes.isEmpty) {
      schoolDcNoerror = "Select classes";
      setState(() {});
    } else {
      schoolDcNoerror = null;
      setState(() {});
      showDialogBox(astraBarCode);
    }
  }

  Future<void> showDialogBox(BarCodes astraBarCode) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Check Data"),
        content: Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          width: 400,
          height: 450,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Text(
                        "DC No : ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        schoolDcNo.text,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Nur : ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Expanded(
                        child: Wrap(children: [
                          ...classInfo[0].where((e) => e[0]).toList().map((a) => Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Chip(
                                  label: Text("${a[1]} - ${a[3]} - ${a[2]}"),
                                ),
                              ))
                        ]),
                      )
                    ],
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "CS  : ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Expanded(
                        child: Wrap(children: [
                          ...classInfo[1].where((e) => e[0]).toList().map((a) => Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Chip(
                                  label: Text("${a[1]} - ${a[3]} - ${a[2]}"),
                                ),
                              ))
                        ]),
                      )
                    ],
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "GK  : ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Expanded(
                        child: Wrap(children: [
                          ...classInfo[2].where((e) => e[0]).toList().map((a) => Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Chip(
                                  label: Text("${a[1]} - ${a[3]} - ${a[2]}"),
                                ),
                              ))
                        ]),
                      )
                    ],
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "PC's  : ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Expanded(
                        child: Wrap(children: [
                          ...classInfo[3].where((e) => e[0]).toList().map((a) => Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Chip(
                                  label: Text("${a[1]} - ${a[3]} - ${a[2]}"),
                                ),
                              ))
                        ]),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              // SharedPreferences pref = await SharedPreferences.getInstance();
              StaticInfo.boxCount = 1;
              StaticInfo.setsCount = 1;
              StaticInfo.saveData(astraBarCode);
              // pref.setString("ASTRA_BAR_INFO", jsonEncode(astraBarCode.getMap()));
              // ClassesList
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClassesList(astraBarCode: astraBarCode)));
            },
            child: const Text("Next"),
          ),
        ],
      ),
    );
    setState(() {});
  }
}
