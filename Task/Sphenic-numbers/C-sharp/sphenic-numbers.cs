using System.Linq;
using System.Collections.Generic;
using static System.Console;

public static class SphenicNumbers
{
    public static void Main()
    {
        var numbers = FindSphenicNumbers(1_000_000).OrderBy(t => t.N).ToList();
        var triplets = numbers.Select(t => t.N).Consecutive().ToList();

        WriteLine("Sphenic numbers up to 1 000");
        numbers.Select(t => t.N).TakeWhile(n => n < 1000).Chunk(15)
            .Select(row => row.Delimit()).ForEach(WriteLine);
        WriteLine();

        WriteLine("Sphenic triplets up to 10 000");
        triplets.TakeWhile(n => n < 10_000).Select(n => (n-2, n-1, n)).Chunk(3)
            .Select(row => row.Delimit()).ForEach(WriteLine);
        WriteLine();

        WriteLine($"Number of sphenic numbers < 1 000 000: {numbers.Count}");
        WriteLine($"Number of sphenic triplets < 1 000 000: {triplets.Count}");
        var (n, (a, b, c)) = numbers[199_999];
        WriteLine($"The 200 000th sphenic number: {n} = {a} * {b} * {c}");
        int t = triplets[4_999];
        WriteLine($"The 5 000th sphenic triplet: {(t-2, t-1, t)}");
    }

    static IEnumerable<(int N, (int, int, int) Factors)> FindSphenicNumbers(int bound)
    {
        var primes = PrimeMath.Sieve(bound / 6).ToList();
        for (int i = 0; i < primes.Count; i++) {
            for (int j = i + 1; j < primes.Count; j++) {
                int p = primes[i] * primes[j];
                if (p >= bound) break;
                for (int k = j + 1; k < primes.Count; k++) {
                    if (primes[k] > bound / p) break;
                    int n = p * primes[k];
                    yield return (n, (primes[i], primes[j], primes[k]));
                }
            }
        }
    }

    static IEnumerable<int> Consecutive(this IEnumerable<int> source)
    {
        var (a, b, c) = (0, 0, 0);
        foreach (int d in source) {
            (a, b, c) = (b, c, d);
            if (b - a == 1 && c - b == 1) yield return c;
        }
    }

    static string Delimit<T>(this IEnumerable<T> source, string separator = " ") =>
        string.Join(separator, source);

    static void ForEach<T>(this IEnumerable<T> source, Action<T> action)
    {
        foreach (T element in source) action(element);
    }
}
