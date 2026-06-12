using System; using System.Collections.Generic;
using System.Linq; using static System.Console; using System.Collections;

class Program {
  static void Main(string[] args) {
    WriteLine ("Multiply two consecutive prime numbers, add an even number," +
      " see if the result is a prime number (up to a limit).");
    int c, lim = 500; var pr = PG.Primes(lim * lim).ToList();
    pr = pr.TakeWhile(x => x < lim).ToList();
    var Lst = new[]{ Tuple.Create(2, 2), Tuple.Create(-20, 20) };
    foreach (var pair in Lst) {
      bool sho = pair.Item1 == pair.Item2;
      for (int ofs = pair.Item1; ofs <= pair.Item2; ofs += ofs == -2 ? 4 : 2) {
        c = 0; string s = ofs.ToString("+0;-#").Insert(1, " ");
        for (int i = 0, j = 1, k; j < pr.Count; i = j++)
          if (PG.isPr(k = pr[i] * pr[j] + ofs))
            if (sho) WriteLine ("   {0,3} * {1,3} {2} = {3,-6}",
              pr[i], pr[j], s, k, c++);
            else c++;
        WriteLine("{0,2} found under {1} for \" {2} \"", c, lim, s);
      } WriteLine (); } } }

class PG { static bool[] flags; public static bool isPr(int x) {
  if (x < 2) return false; return !flags[x]; }
  public static IEnumerable<int> Primes(int lim) {
  flags = new bool[lim + 1]; int j = 3;
  for (int d = 8, sq = 9; sq <= lim; j += 2, sq += d += 8)
    if (!flags[j]) { yield return j;
      for (int k = sq, i=j<<1; k<=lim; k += i) flags[k] = true; }
  for (; j <= lim; j += 2) if (!flags[j]) yield return j; } }
