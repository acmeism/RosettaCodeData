using System;
using System.Collections.Generic;
class Program
{

    static int[] sq = { 1, 4, 9, 16, 25, 36, 49, 64, 81 };

    static bool isOne(int x)
    {
        while (true)
        {
            if (x == 89) return false;
            int s = 0, t;
            do if ((t = (x % 10) - 1) >= 0) s += sq[t]; while ((x /= 10) > 0);
            if (s == 1) return true;
            x = s;
        }
    }

    static void Main(string[] args)
    {
        const int Max = 10_000_000; DateTime st = DateTime.Now;
        Console.Write("---Happy Numbers---\nThe first 8:");
        int c = 0, i; for (i = 1; c < 8; i++)
            if (isOne(i)) Console.Write("{0} {1}", c == 0 ? "" : ",", i, ++c);
        for (int m = 10; m <= Max; m *= 10)
        {
            Console.Write("\nThe {0:n0}th: ", m);
            for (; c < m; i++) if (isOne(i)) c++;
            Console.Write("{0:n0}", i - 1);
        }
        Console.WriteLine("\nComputation time {0} seconds.", (DateTime.Now - st).TotalSeconds);
    }
}
