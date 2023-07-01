using System;
using System.Collections.Generic;
using System.Linq;
using static System.Console;

class Program
{
    static string fmt(int[] a)
    {
        var sb = new System.Text.StringBuilder();
        for (int i = 0; i < a.Length; i++)
            sb.Append(string.Format("{0,5}{1}",
              a[i], i % 10 == 9 ? "\n" : " "));
        return sb.ToString();
    }

    static void Main(string[] args)
    {
        var sw = System.Diagnostics.Stopwatch.StartNew();
        var pr = PG.Sundaram(15_500_000).Take(1_000_000).ToArray();
        sw.Stop();
        Write("The first 100 odd prime numbers:\n{0}\n",
          fmt(pr.Take(100).ToArray()));
        Write("The millionth odd prime number: {0}", pr.Last());
        Write("\n{0} ms", sw.Elapsed.TotalMilliseconds);
    }
}

class PG
{
    public static IEnumerable<int> Sundaram(int n)
    {
        // yield return 2;
        int i = 1, k = (n + 1) >> 1, t = 1, v = 1, d = 1, s = 1;
        var comps = new bool[k + 1];
        for (; t < k; t = ((++i + (s += d += 2)) << 1) - d - 2)
            while ((t += d + 2) < k)
                comps[t] = true;
        for (; v < k; v++)
            if (!comps[v])
                yield return (v << 1) + 1;
    }
}
