using System; using System.Collections.Generic; using System.Linq;
using T3 = System.Tuple<int, int, int>; using static System.Console;
class Program { static void Main() {
   WriteLine(" \"N\":  Prime Triplet    Adjacent (to previous)\n" +
             " ---- ----------------- -----------------------");
   foreach(var lmt in new double[]{6e3, 1e5, 1e6, 1e7, 1e8}) {
    var pr = PG.Primes((int)lmt); int l = 0, c = 0; bool a;
    foreach (var t in pr) { c += (a = l == t.Item1) ? 1 : 0;
      if (lmt < 1e5) WriteLine("{0,4}: {1,-18} {2}",
        t.Item1 + 1, t, a ? " *" : ""); l = t.Item3; }
    Console.WriteLine ("Up to {0:n0} there are {1:n0} prime triples, " +
      "of which {2:n0} were found to be adjacent.", lmt, pr.Count(), c); } } }

class PG { static bool[] f; static bool isPrT(int x, int y, int z) {
  if (x < 7) return false; return !f[x] && !f[y] && !f[z]; }
  public static IEnumerable<T3> Primes(int l) { f = new bool[l += 6];
  int j, lj, llj, lllj; j = lj = llj = lllj = 3;
  for (int d = 8, s = 9; s < l; lllj = llj, llj = lj, lj = j, j += 2, s += d += 8)
    if (!f[j]) { if (isPrT(lllj, lj, j)) yield return new T3(lllj, lj, j);
      for (int k = s, i = j << 1; k < l; k += i) f[k] = true; }
  for (; j < l; lllj = llj, llj = lj, lj = j, j += 2)
   if (isPrT(lllj, lj, j)) yield return new T3(lllj, lj, j); } }
