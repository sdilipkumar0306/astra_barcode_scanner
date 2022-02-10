class AstraBarCodeInfo {
  String schoolDcNo;
  String className;
  int setsCount;
  List<String> barCode;

  AstraBarCodeInfo({
    required this.schoolDcNo,
    required this.className,
    required this.setsCount,
    required this.barCode,
  });
  factory AstraBarCodeInfo.parseResponse(dynamic data) {
    dynamic info = data["BAR_CODE_INFO"];
    List<String> barCodes = List<String>.empty(growable: true);
    if (info != null) {
      List<dynamic> temp = info;
      barCodes = temp.map((e) => e.toString()).toList();
    }
    return AstraBarCodeInfo(
      schoolDcNo: data["SCHOOL_DC_NO"],
      className: data["CLASS_NAME"],
      setsCount: data["NO_OF_BOOK_SETS"],
      barCode: barCodes,
    );
  }

  Map<String, dynamic> getMap() => {
        "SCHOOL_DC_NO": schoolDcNo,
        "CLASS_NAME": className,
        "NO_OF_BOOK_SETS": setsCount,
        "BAR_CODE_INFO": barCode,
      };
}
