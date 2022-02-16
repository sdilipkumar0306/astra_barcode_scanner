import 'package:astra_bar_code_scanner/pages/modal/basic_info_modal.dart';

class BarCodes {
  final String dcNo;
  final List<ClassInfo> classes;

  BarCodes({required this.dcNo, required this.classes});

  factory BarCodes.parseResponse(dynamic data) {
    List<dynamic>? info = data["CLASS_DETAILS"];
    List<ClassInfo> lcClasses = List<ClassInfo>.empty(growable: true);
    if (info != null) {
      lcClasses = info.map((e) => ClassInfo.parseResponse(e)).toList();
    }
    return BarCodes(dcNo: data["DC_NO"], classes: lcClasses);
  }

  Map<String, dynamic> getMap() => {"DC_NO": dcNo, "CLASS_DETAILS": classes.map((e) => e.getMap()).toList()};
}
