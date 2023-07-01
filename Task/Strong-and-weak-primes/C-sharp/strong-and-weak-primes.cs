using static System.Console;
using static System.Linq.Enumerable;
using System;

public static class StrongAndWeakPrimes
{
    public static void Main() {
        var primes = PrimeGenerator(10_000_100).ToList();
        var strongPrimes = from i in Range(1, primes.Count - 2) where primes[i] > (primes[i-1] + primes[i+1]) / 2 select primes[i];
        var weakPrimes = from i in Range(1, primes.Count - 2) where primes[i] < (primes[i-1] + primes[i+1]) / 2.0 select primes[i];
        WriteLine($"First 36 strong primes: {string.Join(", ", strongPrimes.Take(36))}");
        WriteLine($"There are {strongPrimes.TakeWhile(p => p < 1_000_000).Count():N0} strong primes below {1_000_000:N0}");
        WriteLine($"There are {strongPrimes.TakeWhile(p => p < 10_000_000).Count():N0} strong primes below {10_000_000:N0}");
        WriteLine($"First 37 weak primes: {string.Join(", ", weakPrimes.Take(37))}");
        WriteLine($"There are {weakPrimes.TakeWhile(p => p < 1_000_000).Count():N0} weak primes below {1_000_000:N0}");
        WriteLine($"There are {weakPrimes.TakeWhile(p => p < 10_000_000).Count():N0} weak primes below {1_000_000:N0}");
    }

}
