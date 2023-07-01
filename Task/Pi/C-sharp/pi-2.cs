using System;
using System.Collections.Generic;
using System.Linq;
using System.Numerics;

namespace EnumeratePi {
  class Program {
    private const int N = 60;
    private const string ZS = " +-";
    static void Main() {
      Console.WriteLine("Digits of PI");
      Console.WriteLine(new string('=', N + 13));

      Console.WriteLine("Decimal    : {0}", string.Concat(PiDigits(10).Take(N).Select(_ => _.ToString("d"))));
      Console.WriteLine("Binary     : {0}", string.Concat(PiDigits(2).Take(N).Select(_ => _.ToString("d"))));
      Console.WriteLine("Quaternary : {0}", string.Concat(PiDigits(4).Take(N).Select(_ => _.ToString("d"))));
      Console.WriteLine("Octal      : {0}", string.Concat(PiDigits(8).Take(N).Select(_ => _.ToString("d"))));
      Console.WriteLine("Hexadecimal: {0}", string.Concat(PiDigits(16).Take(N).Select(_ => _.ToString("x"))));
      Console.WriteLine("Alphabetic : {0}", string.Concat(PiDigits(26).Take(N).Select(_ => (char) ('A' + _))));
      Console.WriteLine("Fun        : {0}", string.Concat(PiDigits(ZS.Length).Take(N).Select(_ => ZS[(int)_])));

      Console.WriteLine("Nibbles    : {0}", string.Concat(PiDigits(0x10).Take(N/2).Select(_ => string.Format("{0:x1} ", _))));
      Console.WriteLine("Bytes      : {0}", string.Concat(PiDigits(0x100).Take(N/3).Select(_ => string.Format("{0:x2} ", _))));
      Console.WriteLine("Words      : {0}", string.Concat(PiDigits(0x10000).Take(N/5).Select(_ => string.Format("{0:x4} ", _))));
      Console.WriteLine("Dwords     : {0}", string.Concat(PiDigits(0x100000000).Take(N/9).Select(_ => string.Format("{0:x8} ", _))));

      Console.WriteLine(new string('=', N + 13));
      Console.WriteLine("* press any key to exit *");
      Console.ReadKey();
    }

    /// <summary>Enumerates the digits of PI.</summary>
    /// <param name="b">Base of the Numeral System to use for the resulting digits (default = Base.Decimal (10)).</param>
    /// <returns>The digits of PI.</returns>
    static IEnumerable<long> PiDigits(long b = 10) {
      BigInteger
        k = 1,
        l = 3,
        n = 3,
        q = 1,
        r = 0,
        t = 1
        ;

      // skip integer part
      var nr = b * (r - t * n);
      n = b * (3 * q + r) / t - b * n;
      q *= b;
      r = nr;

      for (; ; ) {
        var tn = t * n;
        if (4 * q + r - t < tn) {
          yield return (long)n;
          nr = b * (r - tn);
          n = b * (3 * q + r) / t - b * n;
          q *= b;
        } else {
          t *= l;
          nr = (2 * q + r) * l;
          var nn = (q * (7 * k) + 2 + r * l) / t;
          q *= k;
          l += 2;
          ++k;
          n = nn;
        }
        r = nr;
      }
    }
  }
}
