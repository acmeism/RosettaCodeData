using System.Collections.Generic; using System.Linq; using static System.Console; using static System.Math;

class Program {

    static bool ispr(int x) { int lim = (int)Sqrt((double)x);
        if (x < 2) return false; if ((x % 3) == 0) return x == 0; bool odd = false;
        for (int d = 5; d <= lim; d += (odd = !odd) ? 2 : 4) {
        if (x % d == 0) return false; } return true; }

    static void Main() {
        int c = 0, d = 0, f, lim = 1000000, l2 = lim / 100; var Frob = PG.Primes((int)Sqrt(lim) + 1).ToArray();
        for (int n = 0, m = 1; m < Frob.Length; n = m++) {
            if ((f = Frob[n] * Frob[m] - Frob[n] - Frob[m]) < l2) d++;
            Write("{0,7:n0}{2} {1}", f , ++c % 10 == 0 ? "\n" : "", ispr(f) ? " " : "*"); }
        Write("\n\nCalculated {0} Frobenius numbers of consecutive primes under {1:n0}, " +
            "of which {2} were under {3:n0}", c, lim, d, l2); } }

class PG { public static IEnumerable<int> Primes(int lim) {
    var flags = new bool[lim + 1]; int j = 3; yield return 2;
    for (int d = 8, sq = 9; sq <= lim; j += 2, sq += d += 8)
      if (!flags[j]) { yield return j;
        for (int k = sq, i = j << 1; k <= lim; k += i) flags[k] = true; }
    for (; j <= lim; j += 2) if (!flags[j]) yield return j; } }
