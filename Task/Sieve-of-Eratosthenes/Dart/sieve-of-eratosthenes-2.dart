import 'dart:typed_data';
import 'dart:math';

Iterable<int> soeOdds(int limit) {
  if (limit < 3) return limit < 2 ? Iterable.empty() : [2];
  int lmti = (limit - 3) >> 1;
  int bfsz = (lmti >> 3) + 1;
  int sqrtlmt = (sqrt(limit) - 3).floor() >> 1;
  Uint32List cmpsts = Uint32List(bfsz);
  for (int i = 0; i <= sqrtlmt; ++i)
    if ((cmpsts[i >> 5] & (1 << (i & 31))) == 0) {
      int p = i + i + 3;
      for (int j = (p * p - 3) >> 1; j <= lmti; j += p)
        cmpsts[j >> 5] |= 1 << (j & 31);
    }
  return
    [2].followedBy(
      Iterable.generate(lmti + 1)
      .where((i) => cmpsts[i >> 5] & (1 << (i & 31)) == 0)
      .map((i) => i + i + 3) );
}

void main() {
  final int range = 100000000;
  String s = "( ";
  primesPaged().take(25).forEach((p)=>s += "$p "); print(s + ")");
  print("There are ${countPrimesTo(1000000)} primes to 1000000.");
  final start = DateTime.now().millisecondsSinceEpoch;
  final answer = soeOdds(range).length;
  final elapsed = DateTime.now().millisecondsSinceEpoch - start;
  print("There were $answer primes found up to $range.");
  print("This test bench took $elapsed milliseconds.");
}
