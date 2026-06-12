using System; using System.Collections.Generic; using static System.Console; using System.Linq; using DT = System.DateTime;

class Program { static void Main(string[] args) { string s;
  foreach (int lmt in new int[]{ 90, 300, 3000, 30000, 111000 }) {
    var pr = PG.Primes(lmt).Skip(1).ToList(); DT st = DT.Now;
    int d, f = 0; var r = new List<string>();
    int i = -1, m, h = (m = lmt / 3), j, k, pra, prab;
    while (i < 0) i = pr.IndexOf(h--); k = (j = i - 1) - 1;
    for (int a = 0; a <= k; a++) { pra = pr[a];
    for (int b = a + 1; b <= j; b++) { prab = pra + pr[b];
    for (int c = b + 1; c <= i; c++) {
      if (PG.flags[d = prab + pr[c]]) continue; f++;
      if (lmt < 100) r.Add(string.Format("{3,5} = {0,2} + {1,2} + {2,2}", pra, pr[b], pr[c], d)); } } }
    s = "s.u.p.t.s under "; r.Sort(); if (r.Count > 0) WriteLine("{0}{1}:\n{2}", s, m, string.Join("\n", r));
    if (lmt > 100) WriteLine("Count of {0}{1,6:n0}: {2,13:n0}  {3} sec", s, m, f, (DT.Now - st).ToString().Substring(6)); } } }

class PG { public static bool[] flags;
  public static IEnumerable<int> Primes(int lim) {
  flags = new bool[lim + 1]; int j = 2;
  for (int d = 3, sq = 4; sq <= lim; j++, sq += d += 2)
    if (!flags[j]) { yield return j;
      for (int k = sq; k <= lim; k += j) flags[k] = true; }
  for (; j <= lim; j++) if (!flags[j]) yield return j; } }
