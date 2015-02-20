import 'dart:math';

List<int> SoEOdds(int limit) {
  List<int> prms = new List();
  if (limit < 2) return prms;
  prms.add(2);
  if (limit < 3) return prms;
  int lmt = (limit - 3) >> 1;
  int bfsz = (lmt >> 5) + 1;
  int sqrtlmt = (sqrt(limit) - 3).floor() >> 1;
  var buf = new List<int>();
  for (int i = 0; i < bfsz; i++)
    buf.add(0);
  for (int i = 0; i <= sqrtlmt; i++)
    if ((buf[i >> 5] & (1 << (i & 31))) == 0) {
      int p = i + i + 3;
      for (int j = (p * p - 3) >> 1; j <= lmt; j += p)
        buf[j >> 5] |= 1 << (j & 31);
    }
  for (int i = 0; i <= lmt; i++)
    if ((buf[i >> 5] & (1 << (i & 31))) == 0)
      prms.add(i + i + 3);
  return prms;
}

void main() {
  int limit = 10000000;
  int strt = new DateTime.now().millisecondsSinceEpoch;
  List<int> primes = SoEOdds(limit);
  int count = primes.length;
  int elpsd = new DateTime.now().millisecondsSinceEpoch - strt;
  print("Found " + count.toString() + " primes up to " + limit.toString() +
        " in " + elpsd.toString() + " milliseconds.");
//  print(iterableToString(primes)); // expect sieve.length to be 168 up to 1000...
}
