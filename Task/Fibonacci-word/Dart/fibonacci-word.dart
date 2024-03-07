import 'dart:math';

class FWord {
  String fWord0 = "";
  String fWord1 = "";

  String nextFWord() {
    String result;

    if (fWord1 == "") {
      result = "1";
    } else if (fWord0 == "") {
      result = "0";
    } else {
      result = fWord1 + fWord0;
    }

    fWord0 = fWord1;
    fWord1 = result;

    return result;
  }

  static double entropy(String source) {
    int length = source.length;
    var counts = <String, int>{};
    double result = 0.0;

    for (int i = 0; i < length; i++) {
      String c = source[i];

      if (counts.containsKey(c)) {
        counts[c] = counts[c] + 1;
      } else {
        counts[c] = 1;
      }
    }

    counts.values.forEach((count) {
      double proportion = count / length;
      result -= proportion * (log(proportion) / log(2));
    });

    return result;
  }

  static void main() {
    FWord fWord = FWord();

    for (int i = 0; i < 37;) {
      String word = fWord.nextFWord();
      print("${++i} ${word.length} ${entropy(word)}");
    }
  }
}

void main() {
  FWord.main();
}
