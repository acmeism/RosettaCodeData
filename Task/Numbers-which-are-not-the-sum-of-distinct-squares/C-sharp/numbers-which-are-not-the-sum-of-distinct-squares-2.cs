using System;
using System.Collections.Generic;
using System.Linq;

class Program {

  static List<int> y = new List<int>();

  // checks permutations of squares in a binary fashion
  static void soms(ref List<int> f, int d) { f.Add(f.Last() + d);
    int l = 1 << f.Count, max = f.Last(), min = max - d;
    var x = new List<int>();
    for (int i = 1; i < l; i++) {
      int j = i, k = 0, r = 0; while (j > 0) {
        if ((j & 1) == 1 && (r += f[k]) >= max) break;
        j >>= 1; k++; } if (r > min && r < max) x.Add(r); }
    for ( ; ++min < max; ) if (!x.Contains(min)) y.Add(min); }

  static void Main() {
    var sw = System.Diagnostics.Stopwatch.StartNew();
    var s = new List<int>{ 1 };
    var sf = "stopped checking after finding {0} sequential non-gaps after the final gap of {1}";
    for (int d = 1; d <= 29; ) soms(ref s, d += 2);
    sw.Stop();
    Console.WriteLine("Numbers which are not the sum of distinct squares:");
    Console.WriteLine(string.Join (", ", y));
    Console.WriteLine("found {0} total in {1} ms",
      y.Count, sw.Elapsed.TotalMilliseconds);
    Console.Write(sf, s.Last()-y.Last(),y.Last());
  }
}
