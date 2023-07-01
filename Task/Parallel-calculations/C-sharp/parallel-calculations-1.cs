using System;
using System.Collections.Generic;
using System.Linq;

class Program
{
    public static List<int> PrimeFactors(int number)
    {
        var primes = new List<int>();
        for (int div = 2; div <= number; div++)
        {
            while (number % div == 0)
            {
                primes.Add(div);
                number = number / div;
            }
        }
        return primes;
    }

    static void Main(string[] args)
    {
        int[] n = { 12757923, 12878611, 12757923, 15808973, 15780709, 197622519 };
        // Calculate each of those numbers' prime factors, in parallel
        var factors = n.AsParallel().Select(PrimeFactors).ToList();
        // Make a new list showing the smallest factor for each
        var smallestFactors = factors.Select(thisNumbersFactors => thisNumbersFactors.Min()).ToList();
        // Find the index that corresponds with the largest of those factors
        int biggestFactor = smallestFactors.Max();
        int whatIndexIsThat = smallestFactors.IndexOf(biggestFactor);
        Console.WriteLine("{0} has the largest minimum prime factor: {1}", n[whatIndexIsThat], biggestFactor);
        Console.WriteLine(string.Join(" ", factors[whatIndexIsThat]));
    }
}
