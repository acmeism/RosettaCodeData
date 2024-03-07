import "dart:collection";
import "dart:io";

void main() {
  createJordanPolya();

  final belowHundredMillion = jordanPolyaSet.lastWhere((element) => element <= 100000000, orElse: () => null);
  List<int> jordanPolya = jordanPolyaSet.toList();

  print("The first 50 Jordan-Polya numbers:");
  for (int i = 0; i < 50; i++) {
    // Right-align each number in a 5-character wide space
    stdout.write(jordanPolya[i].toString().padLeft(5));
    if (i % 10 == 9) {
      print(""); // Newline every 10 numbers
    }
  }
  print("");

  print("The largest Jordan-Polya number less than 100 million: ${belowHundredMillion ?? 'Not found'}");
  print("");

  for (int i in [800, 1050, 1800, 2800, 3800]) {
    var decomposition = decompositions[jordanPolya[i - 1]];
    if (decomposition != null) {
      print("The ${i}th Jordan-Polya number is: ${jordanPolya[i - 1]} = ${mapToString(decomposition)}");
    }
  }
}

SplayTreeSet<int> jordanPolyaSet = SplayTreeSet<int>();
Map<int, Map<int, int>> decompositions = {};

void createJordanPolya() {
  jordanPolyaSet.add(1);
  Set<int> nextSet = SplayTreeSet<int>();
  decompositions[1] = {};
  int factorial = 1;

  for (int multiplier = 2; multiplier <= 20; multiplier++) {
    factorial *= multiplier;
    for (int number in jordanPolyaSet) {
      int tempNumber = number;
      while (tempNumber <= 9223372036854775807 ~/ factorial) {
        int original = tempNumber;
        tempNumber *= factorial;
        nextSet.add(tempNumber);
        var originalDecomposition = decompositions[original];
        if (originalDecomposition != null) {
          decompositions[tempNumber] = Map<int, int>.from(originalDecomposition)
            ..update(multiplier, (value) => value + 1, ifAbsent: () => 1);
        }
      }
    }
    jordanPolyaSet.addAll(nextSet);
    nextSet.clear();
  }
}

String mapToString(Map<int, int> map) {
  String result = "";
  map.forEach((key, value) {
    result = "$key!${value == 1 ? '' : '^$value'} * $result";
  });
  return result.isEmpty ? result : result.substring(0, result.length - 3);
}
