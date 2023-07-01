using System;

class Program {

    const long Lm = (long)1e18;
    const string Fm = "D18";

    // provides 5 x 18 = 90 decimal digits
    struct LI { public long lo, ml, mh, hi, tp; }

    static void inc(ref LI d, LI s) { // d += s
        if ((d.lo += s.lo) >= Lm) { d.ml++; d.lo -= Lm; }
        if ((d.ml += s.ml) >= Lm) { d.mh++; d.ml -= Lm; }
        if ((d.mh += s.mh) >= Lm) { d.hi++; d.mh -= Lm; }
        if ((d.hi += s.hi) >= Lm) { d.tp++; d.hi -= Lm; }
        d.tp += s.tp;
    }

    static void dec(ref LI d, LI s) { // d -= s
        if ((d.lo -= s.lo) < 0) { d.ml--; d.lo += Lm; }
        if ((d.ml -= s.ml) < 0) { d.mh--; d.ml += Lm; }
        if ((d.mh -= s.mh) < 0) { d.hi--; d.mh += Lm; }
        if ((d.hi -= s.hi) < 0) { d.tp--; d.hi += Lm; }
        d.tp -= s.tp;
    }

    static LI set(long s) { LI d;
      d.lo = s; d.ml = d.mh = d.hi = d.tp = 0; return d; }

  static string fmt(LI x) { // returns formatted string value of x
    if (x.tp > 0) return x.tp.ToString() + x.hi.ToString(Fm) + x.mh.ToString(Fm) + x.ml.ToString(Fm) + x.lo.ToString(Fm);
    if (x.hi > 0) return x.hi.ToString() + x.mh.ToString(Fm) + x.ml.ToString(Fm) + x.lo.ToString(Fm);
    if (x.mh > 0) return x.mh.ToString() + x.ml.ToString(Fm) + x.lo.ToString(Fm);
    if (x.ml > 0) return x.ml.ToString() + x.lo.ToString(Fm);
    return x.lo.ToString();
  }

  static LI partcount(int n) {
    var P = new LI[n + 1]; P[0] = set(1);
    for (int i = 1; i <= n; i++) {
      int k = 0, d = -2, j = i;
      LI x = set(0);
      while (true) {
        if ((j -= (d += 3) -k) >= 0) inc(ref x, P[j]); else break;
        if ((j -= ++k)         >= 0) inc(ref x, P[j]); else break;
        if ((j -= (d += 3) -k) >= 0) dec(ref x, P[j]); else break;
        if ((j -= ++k)         >= 0) dec(ref x, P[j]); else break;
      }
      P[i] = x;
    }
    return P[n];
  }

  static void Main(string[] args) {
    var sw = System.Diagnostics.Stopwatch.StartNew ();
    var res = partcount(6666); sw.Stop();
    Console.Write("{0}  {1} ms", fmt(res), sw.Elapsed.TotalMilliseconds);
  }
}
