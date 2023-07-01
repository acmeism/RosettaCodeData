using System;
using BI = System.Numerics.BigInteger;
using static System.Console;

class Program {

  static BI isqrt(BI x) { BI q = 1, r = 0, t; while (q <= x) q <<= 2; while (q > 1) {
    q >>= 2; t = x - r - q; r >>= 1; if (t >= 0) { x = t; r += q; } } return r; }

  static string dump(int digs, bool show = false) {
    int gb = 1, dg = ++digs + gb, z;
    BI t1 = 1, t2 = 9, t3 = 1, te, su = 0,
       t = BI.Pow(10, dg <= 60 ? 0 : dg - 60), d = -1, fn = 1;
    for (BI n = 0; n < dg; n++) {
      if (n > 0) t3 *= BI.Pow(n, 6);
      te = t1 * t2 / t3;
      if ((z = dg - 1 - (int)n * 6) > 0) te *= BI.Pow (10, z);
      else te /= BI.Pow (10, -z);
      if (show && n < 10)
        WriteLine("{0,2} {1,62}", n, te * 32 / 3 / t);
      su += te; if (te < 10) {
        if (show) WriteLine("\n{0} iterations required for {1} digits " +
        "after the decimal point.\n", n, --digs); break; }
      for (BI j = n * 6 + 1; j <= n * 6 + 6; j++) t1 *= j;
      t2 += 126 + 532 * (d += 2);
    }
    string s = string.Format("{0}", isqrt(BI.Pow(10, dg * 2 + 3) /
      su / 32 * 3 * BI.Pow((BI)10, dg + 5)));
    return s[0] + "." + s.Substring(1, digs); }

  static void Main(string[] args) {
    WriteLine(dump(70, true)); }
}
