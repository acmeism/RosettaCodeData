using System;
using System.Linq;
using System.Collections;
using System.Collections.Generic;

public static class TwinPrimes
{
    public static void Main()
    {
        CountTwinPrimes(Enumerable.Range(1, 9).Select(i => (int)Math.Pow(10, i)).ToArray());
    }

    private static void CountTwinPrimes(params int[] bounds)
    {
        Array.Sort(bounds);
        int b = 0;
        int count = 0;
        string format = "There are {0:N0} twin primes below {1:N0}";
        foreach (var twin in FindTwinPrimes(bounds[^1])) {
            if (twin.p2 >= bounds[b]) {
                Console.WriteLine(format, count, bounds[b]);
                b++;
            }
            count++;
        }
        Console.WriteLine(format, count, bounds[b]);
    }

    private static IEnumerable<(int p1, int p2)> FindTwinPrimes(int bound) =>
        PrimeSieve(bound).Pairwise().Where(pair => pair.p1 + 2 == pair.p2);

    private static IEnumerable<int> PrimeSieve(int bound)
    {
        if (bound < 2) yield break;
        yield return 2;

        var composite = new BitArray((bound - 1) / 2);
        int limit = (int)(Math.Sqrt(bound) - 1) / 2;
        for (int i = 0; i < limit; i++) {
            if (composite[i]) continue;
            int prime = 2 * i + 3;
            yield return prime;
            for (int j = (prime * prime - 2) / 2; j < composite.Count; j += prime) {
                composite[j] = true;
            }
        }
        for (int i = limit; i < composite.Count; i++) {
            if (!composite[i]) yield return 2 * i + 3;
        }
    }

    private static IEnumerable<(T p1, T p2)> Pairwise<T>(this IEnumerable<T> source)
    {
        using var e = numbers.GetEnumerator();
        if (!e.MoveNext()) yield break;
        T p1 = e.Current;
        while (e.MoveNext()) {
            T p2 = e.Current;
            yield return (p1, p2);
            p1 = p2;
        }
    }
}
