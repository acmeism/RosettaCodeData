using System;
using System.Collections.Generic;
using System.Linq;
using System.Numerics;

namespace NamesOfGod
{
    public class RowSummer
    {
        const int N = 100000;
        public BigInteger[] p;

        private void calc(int n)
            /* Translated from C */
        {
            p[n] = 0;

            for (int k = 1; k <= n; k++)
            {
                int d = n - k * (3 * k - 1) / 2;
                if (d < 0) break;

                if ((k & 1) != 0) p[n] += p[d];
                else p[n] -= p[d];

                d -= k;
                if (d < 0) break;

                if ((k & 1) != 0) p[n] += p[d];
                else p[n] -= p[d];
            }

        }
        public void PrintSums()
            /* translated from C */
        {
            p = new BigInteger[N + 1];
            var idx = new int[] { 23, 123, 1234, 12345, 20000, 30000, 40000, 50000, N, 0 };
            int at = 0;

            p[0] = 1;

            for (int i = 1; idx[at] > 0; i++)
            {
                calc(i);
                if (i != idx[at]) continue;
                Console.WriteLine(i + ":\t" + p[i]);
                at++;
            }
        }
    }

    public class RowPrinter
        /* translated from Python */
    {
        List<List<int>> cache;
        public RowPrinter()
        {
            cache = new List<List<int>> { new List<int> { 1 } };
        }
        public List<int> cumu(int n)
        {
            for (int l = cache.Count; l < n + 1; l++)
            {
                var r = new List<int> { 0 };
                for (int x = 1; x < l + 1; x++)
                    r.Add(r.Last() + cache[l - x][Math.Min(x, l - x)]);
                cache.Add(r);
            }
            return cache[n];
        }
        public List<int> row(int n)
        {
            var r = cumu(n);
            return (from i in Enumerable.Range(0, n) select r[i + 1] - r[i]).ToList();
        }
        public void PrintRows()
        {
            var rows = Enumerable.Range(1, 25).Select(x => string.Join(" ", row(x))).ToList();
            var widest = rows.Last().Length;
            foreach (var r in rows)
                Console.WriteLine(new String(' ', (widest - r.Length) / 2) + r);
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            var rpr = new RowPrinter();
            rpr.PrintRows();
            var ros = new RowSummer();
            ros.PrintSums();
            Console.ReadLine();
        }
    }
}
