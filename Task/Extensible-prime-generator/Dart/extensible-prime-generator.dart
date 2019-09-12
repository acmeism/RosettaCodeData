Iterable<int> primesMap() {
    Iterable<int> oddprms() sync* {
      yield(3); yield(5); // need at least 2 for initialization
      final Map<int, int> bpmap = {9: 6};
      final Iterator<int> bps = oddprms().iterator;
      bps.moveNext(); bps.moveNext(); // skip past 3 to 5
      int bp = bps.current;
      int n = bp;
      int q = bp * bp;
      while (true) {
        n += 2;
        while (n >= q || bpmap.containsKey(n)) {
          if (n >= q) {
            final int inc = bp << 1;
            bpmap[bp * bp + inc] = inc;
            bps.moveNext(); bp = bps.current; q = bp * bp;
          } else {
            final int inc = bpmap.remove(n);
            int next = n + inc;
            while (bpmap.containsKey(next)) {
              next += inc;
            }
            bpmap[next] = inc;
          }
          n += 2;
        }
        yield(n);
      }
    }
    return [2].followedBy(oddprms());
}

void main() {
  print("The first 20 primes:");
  String str = "( ";
  primesMap().take(20).forEach((p)=>str += "$p "); print(str + ")");
  print("Primes between 100 and 150:");
  str = "( ";
  primesMap().skipWhile((p)=>p<100).takeWhile((p)=>p<150)
    .forEach((p)=>str += "$p "); print(str + ")");
  print("Number of primes between 7700 and 8000: ${
    primesMap().skipWhile((p)=>p<7700).takeWhile((p)=>p<8000).length
  }");
  print("The 10,000th prime:  ${
    primesMap().skip(9999).first
  }");
  final start = DateTime.now().millisecondsSinceEpoch;
  final answer = primesMap().takeWhile((p)=>p<2000000).reduce((a,p)=>a+p);
  final elapsed = DateTime.now().millisecondsSinceEpoch - start;
}
