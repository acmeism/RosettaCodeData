using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;

static class Program {
    static int[] MianChowla(int n) {
        int[] mc = new int[n - 1 + 1];
        HashSet<int> sums = new HashSet<int>(), ts = new HashSet<int>();
        int sum; mc[0] = 1; sums.Add(2);
        for (int i = 1; i <= n - 1; i++) {
            for (int j = mc[i - 1] + 1; ; j++) {
                mc[i] = j;
                for (int k = 0; k <= i; k++) {
                    sum = mc[k] + j;
                    if (sums.Contains(sum)) { ts.Clear(); break; }
                    ts.Add(sum);
                }
                if (ts.Count > 0) { sums.UnionWith(ts); break; }
            }
        }
        return mc;
    }

    static void Main(string[] args)
    {
        const int n = 100; Stopwatch sw = new Stopwatch();
        string str = " of the Mian-Chowla sequence are:\n";
        sw.Start(); int[] mc = MianChowla(n); sw.Stop();
        Console.Write("The first 30 terms{1}{2}{0}{0}Terms 91 to 100{1}{3}{0}{0}" +
            "Computation time was {4}ms.{0}", '\n', str, string.Join(" ", mc.Take(30)),
            string.Join(" ", mc.Skip(n - 10)), sw.ElapsedMilliseconds);
    }
}
