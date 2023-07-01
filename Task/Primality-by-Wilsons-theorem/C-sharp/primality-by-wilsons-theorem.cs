using System;
using System.Linq;
using System.Collections;
using static System.Console;
using System.Collections.Generic;
using BI = System.Numerics.BigInteger;

class Program {

  // initialization
    const int fst = 120, skp = 1000, max = 1015; static double et1, et2; static DateTime st;
    static string ms1 = "Wilson's theorem method", ms2 = "Sieve of Eratosthenes method",
       fmt = "--- {0} ---\n\nThe first {1} primes are:", fm2 = "{0} prime thru the {1} prime:";
    static List<int> lst = new List<int>();

  // dumps a chunk of the prime list (lst)
    static void Dump(int s, int t, string f) {
        foreach (var item in lst.Skip(s).Take(t)) Write(f, item); WriteLine("\n"); }

  // returns the ordinal string representation of a number
    static string Ord(int x, string fmt = "{0:n0}") {
      var y = x % 10; if ((x % 100) / 10 == 10 || y > 3) y = 0;
      return string.Format(fmt, x) + "thstndrd".Substring(y << 1, 2); }

  // shows the results of one type of prime tabulation
    static void ShowOne(string title, ref double et) {
        WriteLine(fmt, title, fst); Dump(0, fst, "{0,-3} ");
        WriteLine(fm2, Ord(skp), Ord(max)); Dump(skp - 1, max - skp + 1, "{0,4} ");
        WriteLine("Time taken: {0}ms\n", et = (DateTime.Now - st).TotalMilliseconds); }

  // for stand-alone computation
    static BI factorial(int n) { BI res = 1; if (n < 2) return res;
        while (n > 0) res *= n--; return res; }

    static bool WTisPrimeSA(int n) { return ((factorial(n - 1) + 1) % n) == 0; }

    static BI[] facts;

    static void initFacts(int n) {
        facts = new BI[n]; facts[0] = facts[1] = 1;
        for (int i = 1, j = 2; j < n; i = j++)
            facts[j] = facts[i] * j; }

    static bool WTisPrime(int n) { return ((facts[n - 1] + 1) % n) == 0; }
  // end stand-alone

    static void Main(string[] args) { st = DateTime.Now;
        BI f = 1; for (int n = 2; lst.Count < max; f *= n++) if ((f + 1) % n == 0) lst.Add(n);
        ShowOne(ms1, ref et1);
        st = DateTime.Now; int lmt = lst.Last(); lst.Clear(); BitArray flags = new BitArray(lmt + 1);
        for (int n = 2; n <= lmt; n+=n==2?1:2) if (!flags[n]) {
                lst.Add(n); for (int k = n * n, n2=n<<1; k <= lmt; k += n2) flags[k] = true; }
        ShowOne(ms2, ref et2);
        WriteLine("{0} was {1:0.0} times slower than the {2}.", ms1, et1 / et2, ms2);

      // stand-alone computation
        WriteLine("\n" + ms1 + " stand-alone computation:");
        WriteLine("factorial computed for each item");
        st = DateTime.Now;
        for (int x = lst[skp - 1]; x <= lst[max - 1]; x++) if (WTisPrimeSA(x)) Write("{0,4} ", x);
        WriteLine(); WriteLine("\nTime taken: {0}ms\n", (DateTime.Now - st).TotalMilliseconds);

        WriteLine("factorials precomputed up to highest item");
        st = DateTime.Now; initFacts(lst[max - 1]);
        for (int x = lst[skp - 1]; x <= lst[max - 1]; x++) if (WTisPrime(x)) Write("{0,4} ", x);
        WriteLine(); WriteLine("\nTime taken: {0}ms\n", (DateTime.Now - st).TotalMilliseconds);
    }
}
