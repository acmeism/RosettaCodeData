import 'dart:math';

void main() {
  final List<List<int>> tests = [
    <int>[],
    <int>[1, 2, 3, 4, 5],
    <int>[1, 3, 5, 7, 9],
    <int>[2, 4, 6, 8, 10],
    <int>[2, 3, 5, 7],
    <int>[8]
  ];

  print('     Set A              Set B         J(A, B)');
  print('---------------------------------------------');
  for (var a in tests) {
    for (var b in tests) {
      print('${a.toString().padRight(19)}${b.toString().padRight(19)}${jaccardIndex(a, b).toStringAsFixed(5)}');
    }
  }
}

double jaccardIndex(List<int> A, List<int> B) {
  // Create sets from the lists
  Set<int> setA = A.toSet();
  Set<int> setB = B.toSet();

  // Calculate intersection
  Set<int> intersection = setA.intersection(setB);

  // Calculate union
  Set<int> union = setA.union(setB);

  final int i = intersection.length;
  final int u = union.length;

  return (u == 0) ? 1.0 : (i == 0) ? 0.0 : i / u;
}
