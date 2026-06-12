import 'package:more/more.dart';

void main(List<String> args) {
  const lim = 10000000;
  final sieve = EulerPrimeSieve(lim * 2); // Add some headroom...
  final s = [
    1, // By convention
    ...2
        .to(maxSafeInteger)
        .where((int n) =>
            Multiset.from(sieve.factorize(n)).elementCounts.max() < 3)
        .take(lim - 1)
        .map((e) => sieve.factorize(e).last)
  ];
  print("First 100 terms:\n${s.take(100).toList()}");
  print(0
      .to(5)
      .map((e) => 10.pow(e + 3).toInt())
      .map((e) => "${e}th term:  ${s[e - 1]}")
      .join('\n'));
}
