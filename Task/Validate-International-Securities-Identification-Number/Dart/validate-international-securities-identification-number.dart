bool checkISIN(String isin) {
  int j = 0, v = 0;
  List<int> s = List.filled(24, 0);

  for (int i = 0; i < 12; i++) {
    int k = isin.codeUnitAt(i);
    if (k >= '0'.codeUnitAt(0) && k <= '9'.codeUnitAt(0)) {
      if (i < 2) return false;
      s[j++] = k - '0'.codeUnitAt(0);
    } else if (k >= 'A'.codeUnitAt(0) && k <= 'Z'.codeUnitAt(0)) {
      if (i == 11) return false;
      k -= 'A'.codeUnitAt(0) - 10;
      s[j++] = k ~/ 10;
      s[j++] = k % 10;
    } else {
      return false;
    }
  }

  if (isin.length > 12) return false;

  for (int i = j - 2; i >= 0; i -= 2) {
    int k = 2 * s[i];
    v += k > 9 ? k - 9 : k;
  }

  for (int i = j - 1; i >= 0; i -= 2) {
    v += s[i];
  }

  return v % 10 == 0;
}

void main() {
  List<String> test = [
    "US0378331005",
    "US0373831005",
    "U50378331005",
    "US03378331005",
    "AU0000XVGZA3",
    "AU0000VXGZA3",
    "FR0000988040"
  ];

  for (String isin in test) {
    print('$isin - ${checkISIN(isin)}');
  }
}
