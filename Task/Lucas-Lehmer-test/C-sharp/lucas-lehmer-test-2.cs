using System;
using System.Collections.Generic;
using System.Numerics;
using System.Threading.Tasks;

public class Program {

    static int[] oddPrimes = new int[] { 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47 };

    static void Main()  {
        int iExpMax = 11213;
        List<int> mn = new List<int>(), res = new List<int>();
        DateTime st = DateTime.Now;
        for (bool skip = false; iExpMax >= 2; iExpMax--, skip = false) {
            for (int i = 2; i * i <= iExpMax; i += i == 2 ? 1 : 2)
                if (iExpMax % i == 0) { skip = true; continue; }
            if (!skip) mn.Add(iExpMax); }
        Parallel.ForEach(mn, e => {
            if (e == 2) { res.Add(2); return; }
            // trial division
            BigInteger m = BigInteger.Pow(2, e) - 1;
            for (long k = 1, ee = e << 1, q = ee + 1; k <= 100000 && q < m; k++, q += ee) {
                bool cont = false;
                foreach (int j in oddPrimes) if (q % j == 0) { cont = true; break; }
                if (cont || ((q & 7) != 1 && (q & 7) != 7)) continue;
                if (m % q == 0) return; }
            // main event
            BigInteger s = 4, mask = BigInteger.Pow(2, e) - 1, msk2 = mask + 2;
            for (int j = e; j > 2; j--) {
                s = ((s *= s) & mask) + (s >> e); s -= s >= mask ? msk2 : 2; }
            if (s == 0) res.Add(e);
        });
        res.Sort(); foreach (int item in res) Console.Write("M{0} ", item);
        Console.WriteLine("\n{0}", DateTime.Now - st);
        if (System.Diagnostics.Debugger.IsAttached) Console.ReadLine();
    }
}
