using System;
using System.Collections.Generic;
using static System.Linq.Enumerable;

public static class SuccessivePrimeDifferences {

    public static void Main() {
        var primes = GeneratePrimes(1_000_000).ToList();
        foreach (var d in new[] {
            new [] { 2 },
            new [] { 1 },
            new [] { 2, 2 },
            new [] { 2, 4 },
            new [] { 4, 2 },
            new [] { 6, 4, 2 },
        }) {
            IEnumerable<int> first = null, last = null;
            int count = 0;
            foreach (var grp in FindDifferenceGroups(d)) {
                if (first == null) first = grp;
                last = grp;
                count++;
            }
            Console.WriteLine($"{$"({string.Join(", ", first)})"}, {$"({string.Join(", ", last)})"}, {count}");
        }

        IEnumerable<IEnumerable<int>> FindDifferenceGroups(int[] diffs) {
            for (int pi = diffs.Length; pi < primes.Count; pi++)
                if (Range(0, diffs.Length).All(di => primes[pi-diffs.Length+di+1] - primes[pi-diffs.Length+di] == diffs[di]))
                    yield return Range(pi - diffs.Length, diffs.Length + 1).Select(i => primes[i]);
        }

        IEnumerable<int> GeneratePrimes(int lmt) {
            bool[] comps = new bool[lmt + 1];
            comps[0] = comps[1] = true;
            yield return 2; yield return 3;
            for (int j = 4; j <= lmt; j += 2) comps[j] = true;
            for (int j = 9; j <= lmt; j += 6) comps[j] = true;
            int i = 5, d = 4, rt = (int)Math.Sqrt(lmt);
            for ( ; i <= rt; i += (d = 6 - d))
                if (!comps[i]) {
                    yield return i;
                    for (int j = i * i, k = i << 1; j <= lmt; j += k)
                        comps[j] = true;
                }
            for ( ; i <= lmt; i += (d = 6 - d)) if (!comps[i]) yield return i;
        }
    }
}
