using System;
using System.Collections.Generic;
using System.Linq;

class Program {

  // recursively permutates the list of squares to seek a matching sum
  static bool soms(int n, IEnumerable<int> f) {
    if (n <= 0) return false;
    if (f.Contains(n)) return true;
    switch(n.CompareTo(f.Sum())) {
      case 1: return false;
      case 0: return true;
      case -1:
        var rf = f.Reverse().Skip(1).ToList();
        return soms(n - f.Last(), rf) || soms(n, rf);
    }
    return false;
  }

  static void Main() {
    var sw = System.Diagnostics.Stopwatch.StartNew();
    int c = 0, r, i, g; var s = new List<int>(); var a = new List<int>();
    var sf = "stopped checking after finding {0} sequential non-gaps after the final gap of {1}";
    for (i = 1, g = 1; g >= (i >> 1); i++) {
      if ((r = (int)Math.Sqrt(i)) * r == i) s.Add(i);
      if (!soms(i, s)) a.Add(g = i);
    }
    sw.Stop();
    Console.WriteLine("Numbers which are not the sum of distinct squares:");
    Console.WriteLine(string.Join(", ", a));
    Console.WriteLine(sf, i - g, g);
    Console.Write("found {0} total in {1} ms",
      a.Count, sw.Elapsed.TotalMilliseconds);
  }
}
