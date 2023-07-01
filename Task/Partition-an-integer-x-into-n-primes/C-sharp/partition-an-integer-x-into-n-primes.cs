using System;
using System.Collections;
using System.Collections.Generic;
using static System.Linq.Enumerable;

public static class Rosetta
{
    static void Main()
    {
        foreach ((int x, int n) in new [] {
            (99809, 1),
            (18, 2),
            (19, 3),
            (20, 4),
            (2017, 24),
            (22699, 1),
            (22699, 2),
            (22699, 3),
            (22699, 4),
            (40355, 3)
        }) {
            Console.WriteLine(Partition(x, n));
        }
    }

    public static string Partition(int x, int n) {
        if (x < 1 || n < 1) throw new ArgumentOutOfRangeException("Parameters must be positive.");
        string header = $"{x} with {n} {(n == 1 ? "prime" : "primes")}: ";
        int[] primes = SievePrimes(x).ToArray();
        if (primes.Length < n) return header + "not enough primes";
        int[] solution = CombinationsOf(n, primes).FirstOrDefault(c => c.Sum() == x);
        return header + (solution == null ? "not possible" : string.Join("+", solution);
    }

    static IEnumerable<int> SievePrimes(int bound) {
        if (bound < 2) yield break;
        yield return 2;

        BitArray composite = new BitArray((bound - 1) / 2);
        int limit = ((int)(Math.Sqrt(bound)) - 1) / 2;
        for (int i = 0; i < limit; i++) {
            if (composite[i]) continue;
            int prime = 2 * i + 3;
            yield return prime;
            for (int j = (prime * prime - 2) / 2; j < composite.Count; j += prime) composite[j] = true;
        }
        for (int i = limit; i < composite.Count; i++) {
            if (!composite[i]) yield return 2 * i + 3;
        }
    }

    static IEnumerable<int[]> CombinationsOf(int count, int[] input) {
        T[] result = new T[count];
        foreach (int[] indices in Combinations(input.Length, count)) {
            for (int i = 0; i < count; i++) result[i] = input[indices[i]];
            yield return result;
        }
    }

    static IEnumerable<int[]> Combinations(int n, int k) {
        var result = new int[k];
        var stack = new Stack<int>();
        stack.Push(0);
        while (stack.Count > 0) {
            int index = stack.Count - 1;
            int value = stack.Pop();
            while (value < n) {
                result[index++] = value++;
                stack.Push(value);
                if (index == k) {
                    yield return result;
                    break;
                }
            }
        }
    }

}
