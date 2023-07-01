import 'package:collection/collection.dart';
import 'dart:collection';
List<int> hailstone(int n) {
  if(n <= 0) {
    throw ArgumentError("start value must be >=1)");
  }
  var seq = Queue<int>();
  seq.add(n);
  while(n != 1) {
    n = n%2 == 0 ? n ~/ 2 : 3 * n + 1;
    seq.add(n);
  }
  return seq.toList();
}

main() {
  for(int i = 1; i <= 10; i++) {
    print("h($i) = ${hailstone(i)}");
  }
  var h27 = hailstone(27);
  var first4 = h27.take(4).toList();
  print("first 4 elements of h(27): $first4");
  assert(ListEquality().equals([27, 82, 41, 124], first4));

  var last4 = h27.skip(h27.length - 4).take(4).toList();
  print("last 4 elements of h(27): $last4");
  assert(ListEquality().equals([8, 4, 2, 1], last4));

  print("length of sequence h(27): ${h27.length}");
  assert(112 == h27.length);

  int seq = 0, max = 0;
  for(int i = 1; i <= 100000; i++) {
    var h = hailstone(i);
    if(h.length > max) {
      max = h.length;
      seq = i;
    }
  }
  print("up to 100000 the sequence h($seq) has the largest length ($max)");
}
