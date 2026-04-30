import 'dart:math';

String deBruijn(int k, int n) {
  List<int> a = List.filled(k * n, 0);
  List<int> seq = [];

  void db(int t, int p) {
    if (t > n) {
      if (n % p == 0) {
        for (int i = 1; i < p + 1; i++) {
          seq.add(a[i]);
        }
      }
    } else {
      a[t] = a[t - p];
      db(t + 1, p);
      int j = a[t - p] + 1;
      while (j < k) {
        a[t] = j;
        db(t + 1, t);
        j++;
      }
    }
  }

  db(1, 1);

  StringBuffer buf = StringBuffer();
  for (int i in seq) {
    buf.write(String.fromCharCode(i + '0'.codeUnitAt(0)));
  }
  String result = buf.toString() + buf.toString().substring(0, n - 1);
  return result;
}

bool allDigits(String s) {
  for (int i = 0; i < s.length; i++) {
    if (s.codeUnitAt(i) < '0'.codeUnitAt(0) || s.codeUnitAt(i) > '9'.codeUnitAt(0)) {
      return false;
    }
  }
  return true;
}

void validate(String db) {
  int le = db.length;
  List<int> found = List.filled(10000, 0);
  List<String> errs = [];

  for (int i = 0; i < le - 3; i++) {
    String s = db.substring(i, i + 4);
    if (allDigits(s)) {
      int n = int.parse(s);
      found[n]++;
    }
  }

  for (int i = 0; i < 10000; i++) {
    if (found[i] == 0) {
      errs.add("    PIN number $i missing");
    } else if (found[i] > 1) {
      errs.add("    PIN number $i occurs ${found[i]} times");
    }
  }

  if (errs.isEmpty) {
    print("  No errors found");
  } else {
    String pl = (errs.length == 1) ? "" : "s";
    print("  ${errs.length} error$pl found:");
    for (String e in errs) {
      print(e);
    }
  }
}

void main() {
  String db = deBruijn(10, 4);
  print("The length of the de Bruijn sequence is ${db.length}\n");

  print("The first 130 digits of the de Bruijn sequence are: ${db.substring(0, 130)}");
  print("\nThe last 130 digits of the de Bruijn sequence are: ${db.substring(db.length - 130)}");

  print("\nValidating the de Bruijn sequence:");
  validate(db);

  print("\nValidating the reversed de Bruijn sequence:");
  String rdb = db.split('').reversed.join();
  validate(rdb);

  String by = db;
  by = by.substring(0, 4443) + '.' + by.substring(4444);
  print("\nValidating the overlaid de Bruijn sequence:");
  validate(by);
}
