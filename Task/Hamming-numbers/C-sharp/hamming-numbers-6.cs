using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Numerics;

class HammingsLogArr : IEnumerable<Tuple<uint, uint, uint>> {
  public static BigInteger trival(Tuple<uint, uint, uint> tpl) {
    BigInteger rslt = 1;
    for (var i = 0; i < tpl.Item1; ++i) rslt *= 2;
    for (var i = 0; i < tpl.Item2; ++i) rslt *= 3;
    for (var i = 0; i < tpl.Item3; ++i) rslt *= 5;
    return rslt;
  }
  private const double lb3 = 1.5849625007211561814537389439478; // Math.Log(3) / Math.Log(2);
  private const double lb5 = 2.3219280948873623478703194294894; // Math.Log(5) / Math.Log(2);
  private struct logrep {
    public double lg;
    public uint x2, x3, x5;
    public logrep(double lg, uint x, uint y, uint z) {
      this.lg = lg; this.x2 = x; this.x3 = y; this.x5 = z;
    }
    public logrep mul2() {
      return new logrep (this.lg + 1.0, this.x2 + 1, this.x3, this.x5);
    }
    public logrep mul3() {
      return new logrep(this.lg + lb3, this.x2, this.x3 + 1, this.x5);
    }
    public logrep mul5() {
      return new logrep(this.lg + lb5, this.x2, this.x3, this.x5 + 1);
    }
  }
  public IEnumerator<Tuple<uint, uint, uint>> GetEnumerator() {
    var one = new logrep();
    var s2 = new List<logrep>(); var s3 = new List<logrep>();
    s2.Add(one); s3.Add(one.mul3());
    var s5 = one.mul5(); var mrg = one.mul3();
    var s2hdi = 0; var s3hdi = 0;
    while (true) {
      if (s2hdi >= s2.Count) { s2.RemoveRange(0, s2hdi); s2hdi = 0; } // assume capacity stays the same...
      var v = s2[s2hdi];
      if ( v.lg < mrg.lg) { s2.Add(v.mul2()); s2hdi++; }
      else {
        if (s3hdi >= s3.Count) { s3.RemoveRange(0, s3hdi); s3hdi = 0; }
        v = mrg; s2.Add(v.mul2()); s3.Add(v.mul3());
        s3hdi++; var chkv = s3[s3hdi];
        if (chkv.lg < s5.lg) { mrg = chkv; }
        else { mrg = s5; s5 = s5.mul5(); s3hdi--; }
      }
      yield return Tuple.Create(v.x2, v.x3, v.x5);
    }
  }
  IEnumerator IEnumerable.GetEnumerator() {
    return this.GetEnumerator();
  }
}

class Program {
  static void Main(string[] args) {
    Console.WriteLine(String.Join(" ", (new HammingsLogArr()).Take(20)
                                        .Select(t => HammingsLogArr.trival(t))
                                        .ToArray()));
    Console.WriteLine(HammingsLogArr.trival((new HammingsLogArr()).ElementAt((int)1691 - 1)));

    var n = 1000000UL;
    var elpsd = -DateTime.Now.Ticks;

    var rslt = (new HammingsLogArr()).ElementAt((int)n - 1);

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
