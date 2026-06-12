using System;
using static System.Math;
using static System.Console;
using BI = System.Numerics.BigInteger;

class Program {

    static void Main(string[] args) {
        BI i, j, k, d; i = 2; int n = -1; int n0 = -1;
        j = (BI)Floor(Sqrt((double)i)); k = j; d = j;
        DateTime st = DateTime.Now;
        if (args.Length > 0) int.TryParse(args[0], out n);
        if (n > 0) n0 = n; else n = 1;
        do {
            Write(d); i = (i - k * d) * 100; k = 20 * j;
            for (d = 1; d <= 10; d++)
                if ((k + d) * d > i) { d -= 1; break; }
            j = j * 10 + d; k += d; if (n0 > 0) n--;
        } while (n > 0);
        if (n0 > 0) WriteLine("\nTime taken for {0} digits: {1}", n0, DateTime.Now - st); }

}
