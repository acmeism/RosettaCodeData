import 'package:collection/collection.dart';
import 'package:more/more.dart';

void main() {
  var t = DateTime.now();
  for (var p in 1.to(20)) {
    var c = counts(p)
        .indexed()
        .fold<int>(0, (s, t) => s + (isHappy(t.index) ? 0 : 1) * t.value);
    print('10^$p:\t$c');
  }
  print(DateTime.now().difference(t).inMilliseconds);
}

bool isHappy(int n) => switch (n) {
      0 || 1 => true,
      89 => false,
      _ => isHappy("$n".split('').map((e) => int.parse(e).pow(2) as int).sum)
    };

List<int> counts(int powTen) {
  var max = 81 * powTen + 1;
  var arr = List.filled(max, 0);
  arr[0] = 1; // First pass will copy this 1 to indexes 1, 4, 9, etc
  var ds = 0.to(10).map((e) => e.pow(2) as int).toList();
  for (var _ in 0.to(powTen)) {
    // For each power of ten, take what we already have, and offset
    // a copy by each of our digit-powers. This works, trust me.
    var next = List.filled(max, 0);
    for (var d in ds) {
      for (var i in 0.to(max - d)) {
        next[i + d] += arr[i];
      }
    }
    arr = next;
  }
  arr[0] = 0;
  return arr;
}
