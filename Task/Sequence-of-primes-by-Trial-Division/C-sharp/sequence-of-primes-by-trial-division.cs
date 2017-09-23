using System;
using System.Collections.Generic;
using System.Linq;

public class Program
{
    static void Main() {
        Console.WriteLine(string.Join(" ", Primes(100)));
    }

    static IEnumerable<int> Primes(int limit) => Enumerable.Range(2, limit-2).Where(IsPrime);
    static bool IsPrime(int n) => Enumerable.Range(2, (int)Math.Sqrt(n)-1).All(i => n % i != 0);
}
