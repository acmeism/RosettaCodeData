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
  final int range = 100000000;
  String s = "( ";
  primesMap().take(25).forEach((p)=>s += "$p "); print(s + ")");
  print("There are ${primesMap().takeWhile((p)=>p<=1000000).length} preimes to 1000000.");
  final start = DateTime.now().millisecondsSinceEpoch;
  final answer = primesMap().takeWhile((p)=>p<=range).length;
  final elapsed = DateTime.now().millisecondsSinceEpoch - start;
  print("There were $answer primes found up to $range.");
  print("This test bench took $elapsed milliseconds.");
}
