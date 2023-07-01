using System.Linq;
using System.Collections.Generic;
using TG = System.Tuple<int, int>;
using static System.Console;

class Program
{
    static void Main(string[] args)
    {
        const int mil = (int)1e6;
        foreach (var amt in new int[] { 1, 2, 6, 12, 18 })
        {
            int lmt = mil * amt, lg = 0, ng, d, ld = 0;
            var desc = new string[] { "A", "", "De" };
            int[] mx = new int[] { 0, 0, 0 },
                  bi = new int[] { 0, 0, 0 },
                   c = new int[] { 2, 2, 2 };
            WriteLine("For primes up to {0:n0}:", lmt);
            var pr = PG.Primes(lmt).ToArray();
            for (int i = 0; i < pr.Length; i++)
            {
                ng = pr[i].Item2; d = ng.CompareTo(lg) + 1;
                if (ld == d)
                    c[2 - d]++;
                else
                {
                    if (c[d] > mx[d]) { mx[d] = c[d]; bi[d] = i - mx[d] - 1; }
                    c[d] = 2;
                }
                ld = d; lg = ng;
            }
            for (int r = 0; r <= 2; r += 2)
            {
                Write("{0}scending, found run of {1} consecutive primes:\n  {2} ",
                    desc[r], mx[r] + 1, pr[bi[r]++].Item1);
                foreach (var itm in pr.Skip(bi[r]).Take(mx[r]))
                    Write("({0}) {1} ", itm.Item2, itm.Item1); WriteLine(r == 0 ? "" : "\n");
            }
        }
    }
}

class PG
{
    public static IEnumerable<TG> Primes(int lim)
    {
        bool[] flags = new bool[lim + 1];
        int j = 3, lj = 2;
        for (int d = 8, sq = 9; sq <= lim; j += 2, sq += d += 8)
            if (!flags[j])
            {
                yield return new TG(j, j - lj);
                lj = j;
                for (int k = sq, i = j << 1; k <= lim; k += i) flags[k] = true;
            }
        for (; j <= lim; j += 2)
            if (!flags[j])
            {
                yield return new TG(j, j - lj);
                lj = j;
            }
    }
}
