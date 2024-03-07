import "dart:io";

void main() {
  List<String> tests = [
    "banana",
    "appellee",
    "dogwood",
    "TO BE OR NOT TO BE OR WANT TO BE OR NOT?",
    "SIX.MIXED.PIXIES.SIFT.SIXTY.PIXIE.DUST.BOXES",
    "\u0002ABC\u0003"
  ];
  for (String test in tests) {
    print(makePrintable(test));
    stdout.write(" --> ");
    String t = "";
    try {
      t = bwt(test);
      print(makePrintable(t));
    } catch (e) {
      print("ERROR: ${e.toString()}");
    }
    String r = ibwt(t);
    print(" --> $r\n");
  }
}

const String STX = "\u0002";
const String ETX = "\u0003";

String bwt(String s) {
  if (s.contains(STX) || s.contains(ETX)) {
    throw FormatException("String cannot contain STX or ETX");
  }

  String ss = STX + s + ETX;
  List<String> table = [];
  for (int i = 0; i < ss.length; i++) {
    String before = ss.substring(i);
    String after = ss.substring(0, i);
    table.add(before + after);
  }
  table.sort();

  return table.map((str) => str[str.length - 1]).join();
}

String ibwt(String r) {
  int len = r.length;
  List<String> table = List.filled(len, "");
  for (int j = 0; j < len; ++j) {
    for (int i = 0; i < len; ++i) {
      table[i] = r[i] + table[i];
    }
    table.sort();
  }
  for (String row in table) {
    if (row.endsWith(ETX)) {
      return row.substring(1, len - 1);
    }
  }
  return "";
}

String makePrintable(String s) {
  // substitute ^ for STX and | for ETX to print results
  return s.replaceAll(STX, "^").replaceAll(ETX, "|");
}
