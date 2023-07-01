using System;
using static System.Console;

class Program {

  const int mc = 103 * 1000 * 10000 + 11 * 9 + 1;

  static bool[] sv = new bool[mc + 1];

  static void sieve() { int[] dS = new int[10000];
    for (int a = 9, i = 9999; a >= 0; a--)
      for (int b = 9; b >= 0; b--)
        for (int c = 9, s = a + b; c >= 0; c--)
          for (int d = 9, t = s + c; d >= 0; d--)
            dS[i--] = t + d;
    for (int a = 0, n = 0; a < 103; a++)
      for (int b = 0, d = dS[a]; b < 1000; b++, n += 10000)
        for (int c = 0, s = d + dS[b] + n; c < 10000; c++)
          sv[dS[c] + s++] = true; }

  static void Main() { DateTime st = DateTime.Now; sieve();
    WriteLine("Sieving took {0}s", (DateTime.Now - st).TotalSeconds);
    WriteLine("\nThe first 50 self numbers are:");
    for (int i = 0, count = 0; count <= 50; i++) if (!sv[i]) {
        count++; if (count <= 50) Write("{0} ", i);
        else WriteLine("\n\n       Index     Self number"); }
    for (int i = 0, limit = 1, count = 0; i < mc; i++)
      if (!sv[i]) if (++count == limit) {
          WriteLine("{0,12:n0}   {1,13:n0}", count, i);
          if (limit == 1e9) break; limit *= 10; }
    WriteLine("\nOverall took {0}s", (DateTime.Now - st). TotalSeconds);
  }
}
