using System;
using System.Linq;
using System.Collections.Generic;
					
public static class Program
{
    public static void Main() =>
        Console.WriteLine(string.Join(" ", FindAntiPrimes().Take(20)));
	
    static IEnumerable<int> FindAntiPrimes() {
        int max = 0;
        for (int i = 1; ; i++) {
            int divisors = CountDivisors(i);
            if (divisors > max) {
                max = divisors;
                yield return i;
            }
        }
	
        int CountDivisors(int n) => Enumerable.Range(1, n / 2).Count(i => n % i == 0) + 1;
    }
}
