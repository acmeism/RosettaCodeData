import 'dart:math';
import 'package:more/more.dart';

int nextPrime(int n) {
  while (!n.isProbablyPrime) n++;
  return n;
}

List<int> divisors(int n) {
  var ret = <int>{1, n};
  for (var i in 2.to(sqrt(n).ceil())) {
    if (n % i == 0) ret.addAll([i, n ~/ i]);
  }
  return ret.toList()..sort();
}

Iterable<int> giuga(int n) sync* {
  var p = List<int>.filled(n, 0);
  var s = List<Fraction>.filled(n, Fraction(0));
  var t = p[1] = p[2] = 2;
  s[1] = Fraction(1, 2);
  while (t > 1) {
    var next = p[t] + 1;
    p[t] = next.isProbablyPrime ? next : nextPrime(next);
    s[t] = s[t - 1] + Fraction(1, p[t]);
    if (s[t] == Fraction.one || s[t] + Fraction(n - t, p[t]) <= Fraction.one) {
      t = t - 1;
    } else if (t < n - 2) {
      t = t + 1;
      p[t] = max(p[t - 1], (s[t - 1] / (Fraction.one - s[t - 1])).toInt());
    } else {
      yield* findAnySolutions(n, p, s);
    }
  }
}

Iterable<int> findAnySolutions(int n, List<int> p, List<Fraction> s) sync* {
  var c = s[n - 2].numerator;
  var d = s[n - 2].denominator;
  var k = d * d + c - d;
  var f = divisors(k);
  for (var i in 0.to((f.length ~/ 2))) {
    var h = f[i];
    if ((h + d) % (d - c) == 0 && (k / h + d) % (d - c) == 0) {
      var r1 = (h + d) ~/ (d - c);
      var r2 = (k / h + d) ~/ (d - c);
      if (r1 > p[n - 2] &&
          r2 > p[n - 2] &&
          r1 != r2 &&
          r1.isProbablyPrime &&
          r2.isProbablyPrime) {
        yield d * r1 * r2;
      }
    }
  }
}

void main(List<String> args) {
  var t = DateTime.now();
  print([
    for (var i in 3.to(7))
      for (var g in giuga(i)) g
  ]..sort());
  print("${DateTime.now().difference(t).inMilliseconds} milliseconds");
}
