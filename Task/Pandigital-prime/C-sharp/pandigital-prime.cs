using System;

class Program {
  // Find the highest pandigital number in base 10, excluding or including the digit zero.

  // Since the sum-of-digits of the pandigital numbers 0..9 and 0..8 are respectively 45 and 36, (both
  // divisible by 3 and therefore always composite), we will only be looking at pandigital numbers 0..7

  static void fun(char sp) {
    var sw = System.Diagnostics.Stopwatch.StartNew();
    // The difference between every permutation is a multiple of 9.  To check odds only,
    // start at XXXXXX1 or XXXXXX01 and decrement by 18.
    // It's slightly faster to check pan-digitality before the multi-factor test.

    for (int x = sp == '1' ? 7654321 : 76543201; ; x -= 18) {

      // Tests for pan-digitality of x
      // Check for digits sp through 7.  If a duplicate occurs, at least one of the
      // other required digits sp..7 will be missing, and therefore rejected.
      var s = x.ToString();
      for (var ch = sp; ch < '8'; ch++) if (s.IndexOf(ch) < 0) goto nxt;

      // Multi-factor test
      // There is no check for even numbers since starting on an odd number and stepping by an even number
      if (x % 3 == 0) continue;
      for (int i = 1; i * i < x; ) {
        if (x % (i += 4) == 0) goto nxt;
        if (x % (i += 2) == 0) goto nxt;
      }
      sw.Stop(); Console.WriteLine("{0}..7: {1,10:n0} {2} μs", sp, x, sw.Elapsed.TotalMilliseconds * 1000); break;
      nxt: ;
    }
  }

static void Main(string[] args) {
    fun('1');
    fun('0');
  }
}
