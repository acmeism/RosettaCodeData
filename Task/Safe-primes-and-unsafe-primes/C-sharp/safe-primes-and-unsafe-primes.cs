using static System.Console;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

public static class SafePrimes
{
    public static void Main() {
        HashSet<int> primes = Primes(10_000_000).ToHashSet();
        WriteLine("First 35 safe primes:");
        WriteLine(string.Join(" ", primes.Where(IsSafe).Take(35)));
        WriteLine($"There are {primes.TakeWhile(p => p < 1_000_000).Count(IsSafe):n0} safe primes below {1_000_000:n0}");
        WriteLine($"There are {primes.TakeWhile(p => p < 10_000_000).Count(IsSafe):n0} safe primes below {10_000_000:n0}");
        WriteLine("First 40 unsafe primes:");
        WriteLine(string.Join(" ", primes.Where(IsUnsafe).Take(40)));
        WriteLine($"There are {primes.TakeWhile(p => p < 1_000_000).Count(IsUnsafe):n0} unsafe primes below {1_000_000:n0}");
        WriteLine($"There are {primes.TakeWhile(p => p < 10_000_000).Count(IsUnsafe):n0} unsafe primes below {10_000_000:n0}");

        bool IsSafe(int prime) => primes.Contains(prime / 2);
        bool IsUnsafe(int prime) => !primes.Contains(prime / 2);
    }

    //Method from maths library
    static IEnumerable<int> Primes(int bound) {
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

}
