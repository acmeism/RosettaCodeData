using static System.Console;
using System;
using System.Linq;
using System.Collections.Generic;

public class Program
{
    public static void Main() {
        const int limit = 1_000_000;
        WriteLine("First 20:");
        WriteLine(FindEmirpPrimes(limit).Take(20).Delimit());
        WriteLine();
		
        WriteLine("Between 7700 and 8000:");
        WriteLine(FindEmirpPrimes(limit).SkipWhile(p => p < 7700).TakeWhile(p => p < 8000).Delimit());
        WriteLine();
		
        WriteLine("10000th:");
        WriteLine(FindEmirpPrimes(limit).ElementAt(9999));
    }
	
    private static IEnumerable<int> FindEmirpPrimes(int limit)
    {
        var primes = Primes(limit).ToHashSet();
		
        foreach (int prime in primes) {
            int reverse = prime.Reverse();
            if (reverse != prime && primes.Contains(reverse)) yield return prime;
	}
    }
	
    private static IEnumerable<int> Primes(int bound) {
        if (bound < 2) yield break;
        yield return 2;
		
        BitArray composite = new BitArray((bound - 1) / 2);
        int limit = ((int)(Math.Sqrt(bound)) - 1) / 2;
        for (int i = 0; i < limit; i++) {
            if (composite[i]) continue;
	    int prime = 2 * i + 3;
	    yield return prime;
			
	    for (int j = (prime * prime - 2) / 2; j < composite.Count; j += prime)
	        composite[j] = true;
        }
	for (int i = limit; i < composite.Count; i++)
	    if (!composite[i]) yield return 2 * i + 3;
    }
}

public static class Extensions
{
    public static HashSet<T> ToHashSet<T>(this IEnumerable<T> source) => new HashSet<T>(source);

    private const string defaultSeparator = " ";
    public static string Delimit<T>(this IEnumerable<T> source, string separator = defaultSeparator) =>
        string.Join(separator ?? defaultSeparator, source);

    public static int Reverse(this int number)
    {
	if (number < 0) return -Reverse(-number);
	if (number < 10) return number;
	int reverse = 0;
	while (number > 0) {
	    reverse = reverse * 10 + number % 10;
	    number /= 10;
	}
	return reverse;
    }
}
