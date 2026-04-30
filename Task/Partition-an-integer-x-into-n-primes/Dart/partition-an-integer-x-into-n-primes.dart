import 'package:more/more.dart';

final primes = 1.to(100000).where((e) => e.isProbablyPrime).toList();

void main(List<String> args) {
  var egs = [
    [99809, 1],
    [18, 2],
    [19, 3],
    [20, 4],
    [2017, 24],
    [22699, 1],
    [22699, 2],
    [22699, 3],
    [22699, 4],
    [40355, 3],
  ];
  for (var eg in egs) {
    print('$eg \t${partition(eg.first, primes, eg.last)}');
  }
}

List<int> partition(int n, List<int> primes, int count) {
  var ps = primes.toList();
  if (ps.isEmpty || ps.first > n) return [];
  if (count == 1) return ps.contains(n) ? [n] : [];

  // Try *using* the first prime, then (only if needed) *dropping* it.
  var p = ps.removeAt(0);
  List<int> p1;
  return ((p1 = partition(n - p, ps, count - 1)).isNotEmpty)
      ? (p1..insert(0, p))
      : ((p1 = partition(n, ps, count)));
}
