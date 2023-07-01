using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Numerics;

static class NthHamming {
  public static BigInteger trival(Tuple<uint, uint, uint> tpl) {
    BigInteger rslt = 1;
    for (var i = 0; i < tpl.Item1; ++i) rslt *= 2;
    for (var i = 0; i < tpl.Item2; ++i) rslt *= 3;
    for (var i = 0; i < tpl.Item3; ++i) rslt *= 5;
    return rslt;
  }

  private struct logrep {
    public uint x2, x3, x5;
    public double lg;
    public logrep(uint x, uint y, uint z, double lg) {
      this.x2 = x; this.x3 = y; this.x5 = z; this.lg = lg;
    }
  }

  private const double lb3 = 1.5849625007211561814537389439478; // Math.Log(3) / Math.Log(2);
  private const double lb5 = 2.3219280948873623478703194294894; // Math.Log(5) / Math.Log(2);
  private const double fctr = 6.0 * lb3 * lb5;
  private const double crctn = 2.4534452978042592646620291867186; // Math.Log(Math.sqrt(30.0)) / Math.Log(2.0)

  public static Tuple<uint, uint, uint> findNth(UInt64 n) {
    if (n < 1) throw new Exception("NthHamming.findNth:  argument must be > 0!");
    if (n < 2) return Tuple.Create(0u, 0u, 0u); // trivial case for argument of one
    var lgest = Math.Pow(fctr * (double)n, 1.0/3.0) - crctn; // from WP formula
    var frctn = (n < 1000000000) ? 0.509 : 0.105;
    var lghi = Math.Pow(fctr * ((double)n + frctn * lgest), 1.0/3.0) - crctn;
    var lglo = 2.0 * lgest - lghi; // upper and lower bound of upper "band"
    var count = 0UL; // need 64 bit precision in case...
    var bnd = new List<logrep>();
    for (uint k = 0, klmt = (uint)(lghi / lb5) + 1; k < klmt; ++k) {
      var p = (double)k * lb5;
      for (uint j = 0, jlmt = (uint)((lghi - p) / lb3) + 1; j < jlmt; ++j) {
        var q = p + (double)j * lb3;
        var ir = lghi - q;
        var lg = q + Math.Floor(ir); // current log2 value (estimated)
        count += (ulong)ir + 1;
        if (lg >= lglo) bnd.Add(new logrep((UInt32)ir, j, k, lg));
      }
    }
    if (n > count) throw new Exception("NthHamming.findNth:  band high estimate is too low!");
    var ndx = (int)(count - n);
    if (ndx >= bnd.Count) throw new Exception("NthHamming.findNth:  band low estimate is too high!");
    bnd.Sort((a, b) => (b.lg < a.lg) ? -1 : 1); // sort in decending order

    var rslt = bnd[ndx];
    return Tuple.Create(rslt.x2, rslt.x3, rslt.x5);
  }
}

class Program {
  static void Main(string[] args) {
    Console.WriteLine(String.Join(" ", Enumerable.Range(1,20).Select(i =>
                                          NthHamming.trival(NthHamming.findNth((ulong)i))).ToArray()));
    Console.WriteLine(NthHamming.trival((new HammingsLogArr()).ElementAt(1691 - 1)));

    var n = 1000000000000UL;
    var elpsd = -DateTime.Now.Ticks;

    var rslt = NthHamming.findNth(n);

    elpsd += DateTime.Now.Ticks;

    Console.WriteLine("2^{0} times 3^{1} times 5^{2}", rslt.Item1, rslt.Item2, rslt.Item3);
    var lgrthm = Math.Log10(2.0) * ((double)rslt.Item1 +
                  ((double)rslt.Item2 * Math.Log(3.0) + (double)rslt.Item3 * Math.Log(5.0)) / Math.Log(2.0));
    var pwr = Math.Floor(lgrthm); var mntsa = Math.Pow(10.0, lgrthm - pwr);
    Console.WriteLine("Approximately:  {0}E+{1}", mntsa, pwr);
    var s = HammingsLogArr.trival(rslt).ToString();
    var lngth = s.Length;
    Console.WriteLine("Decimal digits:  {0}", lngth);
    if (lngth <= 10000) {
      var i = 0;
      for (; i < lngth - 100; i += 100) Console.WriteLine(s.Substring(i, 100));
      Console.WriteLine(s.Substring(i));
    }
    Console.WriteLine("The {0}th hamming number took {1} milliseconds", n, elpsd / 10000);

    Console.Write("\r\nPress any key to exit:");
    Console.ReadKey(true);
    Console.WriteLine();
  }
}
