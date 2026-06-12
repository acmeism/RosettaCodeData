void dayCountToYMD(int dc, List<int> ymd) {
  int z = dc - 60;
  int era;
  int doe;
  int yoa;
  int doy;
  int mp;

  if (z >= 0) {
    era = z ~/ 146097;
  } else {
    era = ((z + 1) ~/ 146097) - 1;
  }

  doe = z - era * 146097;
  yoa = (doe - (doe ~/ 1460) + (doe ~/ 36524) - (doe ~/ 146096)) ~/ 365;
  ymd[0] = yoa + era * 400;
  doy = doe - (365 * yoa + yoa ~/ 4 - yoa ~/ 100);
  mp = (5 * doy + 2) ~/ 153;
  ymd[2] = doy - ((153 * mp + 2) ~/ 5) + 1;
  ymd[1] = mp + 3 - 12 * (mp ~/ 10);
  ymd[0] = ymd[0] + (mp ~/ 10);
}

String fmt(int n, int w) {
  return n.toString().padLeft(w, '0');
}

void main() {
  List<int> dayCounts = [0, 109573, 146096];
  List<int> ymd = [0, 0, 0]; // y, m, d

  for (var dc in dayCounts) {
    print('Daycount: $dc');
    for (var j = 0; j <= 5; j++) {
      dayCountToYMD(j * 146097 + dc, ymd);
      String y = fmt(ymd[0], 4);
      String m = fmt(ymd[1], 2);
      String d = fmt(ymd[2], 2);
      print('$d/$m/$y');
    }
    print('');
  }
}
