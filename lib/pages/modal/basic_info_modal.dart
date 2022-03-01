class ClassInfo {
  String className;
  int count;
  String version;
  List<Boxes> boxes;
  List<Boxes> sets;

  ClassInfo({
    required this.className,
    required this.count,
    required this.version,
    required this.boxes,
    required this.sets,
  });
  factory ClassInfo.parseResponse(dynamic data) {
    List<dynamic>? boxInfo = data["BOXES"];
    List<dynamic>? setsInfo = data["SETS"];
    List<Boxes> lcBoxes = List<Boxes>.empty(growable: true);
    List<Boxes> lcSets = List<Boxes>.empty(growable: true);
    if (boxInfo != null) {
      lcBoxes = boxInfo.map((e) => Boxes.parseResponse(e)).toList();
    }
    if (setsInfo != null) {
      lcSets = setsInfo.map((e) => Boxes.parseResponse(e)).toList();
    }
    return ClassInfo(className: data["CLASS_NAME"], count: data["COUNT"], version: data["VERSION"] , boxes: lcBoxes, sets: lcSets);
  }

  Map<String, dynamic> getMap() => {
        "CLASS_NAME": className,
        "COUNT": count,
        "VERSION": version,
        "BOXES": boxes.map((e) => e.getMap()).toList(),
        "SETS": sets.map((e) => e.getMap()).toList(),
      };
}

class Boxes {
  String barCode;
  int boxNumber;
  double weight;

  Boxes({required this.barCode, required this.boxNumber, required this.weight});

  factory Boxes.parseResponse(dynamic data) {
    return Boxes(barCode: data["BAR_CODE"], boxNumber: data["BOX_NUMBER"], weight: data["WEIGHT"]);
  }

  Map<String, dynamic> getMap() => {
        "BAR_CODE": barCode,
        "BOX_NUMBER": boxNumber,
        "WEIGHT": weight,
      };
}
