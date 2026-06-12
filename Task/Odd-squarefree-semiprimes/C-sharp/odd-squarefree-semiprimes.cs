using System; using static System.Console; using System.Collections;
using System.Linq; using System.Collections.Generic;

class Program { static void Main(string[] args) {
    int lmt = 1000, amt, c = 0, sr = (int)Math.Sqrt(lmt), lm2; var res = new List<int>();
    var pr = PG.Primes(lmt / 3 + 5).ToArray(); lm2 = pr.OrderBy(i => Math.Abs(sr - i)).First();
    lm2 = Array.IndexOf(pr, lm2); for (var p = 0; p < lm2; p++) { amt = 0; for (var q = p + 1; amt < lmt; q++)
      res.Add(amt = pr[p] * pr[q]); } res.Sort(); foreach(var item in res.TakeWhile(x => x < lmt))
        Write("{0,4} {1}", item, ++c % 20 == 0 ? "\n" : "");
    Write("\n\nCounted {0} odd squarefree semiprimes under {1}", c, lmt); } }

class PG { public static IEnumerable<int> Primes(int lim) {
    var flags = new bool[lim + 1]; int j = 3;
    for (int d = 8, sq = 9; sq <= lim; j += 2, sq += d += 8)
      if (!flags[j]) { yield return j;
        for (int k = sq, i = j << 1; k <= lim; k += i) flags[k] = true; }
    for (; j <= lim; j += 2) if (!flags[j]) yield return j; } }
