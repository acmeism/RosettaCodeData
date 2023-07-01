#define BI

using System;
using System.Linq;
using System.Collections.Generic;

#if BI
using UI = System.Numerics.BigInteger;
#else
using UI = System.UInt64;
#endif

class Program {
    static void Main(string[] args) {
#if BI
    const int max = 100;
#else
    const int max = 19;
#endif
        List<UI> h = new List<UI> { 1 };
        UI x2 = 2, x3 = 3, x5 = 5, x7 = 7, hm = 2, lim = 10;
        int i = 0, j = 0, k = 0, l = 0, lc = 0, d = 1;
        Console.WriteLine("Digits  Count      Time      Mb used");
        var elpsd = -DateTime.Now.Ticks;
        do {
            h.Add(hm);
            if (hm == x2) x2 = h[++i] << 1;
            if (hm == x3) x3 = (h[++j] << 1) + h[j];
            if (hm == x5) x5 = (h[++k] << 2) + h[k];
            if (hm == x7) x7 = (h[++l] << 3) - h[l];
            hm = x2; if (x3 < hm) hm = x3; if (x5 < hm) hm = x5; if (x7 < hm) hm = x7;
            if (hm >= lim) {
                Console.WriteLine("{0,3} {1,9:n0} {2,9:n0} ms {3,9:n0}", d, h.Count - lc,
                    (elpsd + DateTime.Now.Ticks) / 10000, GC.GetTotalMemory(false) / 1000000);
                lc = h.Count; if (++d > max) break; lim *= 10;
            }
        } while (true);
        Console.WriteLine("{0,13:n0} Total", lc);
        int firstAmt = 50;
        Console.WriteLine("The first {0} humble numbers are: {1}", firstAmt, string.Join(" ",h.Take(firstAmt)));
    }
}
