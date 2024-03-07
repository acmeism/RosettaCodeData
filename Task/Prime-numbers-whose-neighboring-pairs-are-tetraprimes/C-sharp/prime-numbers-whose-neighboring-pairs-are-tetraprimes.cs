using System;
using System.Collections.Generic;

public class PrimeNumbersNeighboringPairsTetraprimes
{
    private static List<int> primes;

    public static void Main(string[] args)
    {
        ListPrimeNumbers(10_000_000);

        int largestPrime5 = LargestLessThan(100_000);
        int largestPrime6 = LargestLessThan(1_000_000);
        int largestPrime7 = primes[primes.Count - 1];
        var tetrasPreceding = new List<int>();
        var tetrasFollowing = new List<int>();
        int sevensPreceding = 0;
        int sevensFollowing = 0;
        int limit = 100_000;

        foreach (var prime in primes)
        {
            if (IsTetraPrime(prime - 1) && IsTetraPrime(prime - 2))
            {
                tetrasPreceding.Add(prime);
                if ((prime - 1) % 7 == 0 || (prime - 2) % 7 == 0)
                {
                    sevensPreceding++;
                }
            }

            if (IsTetraPrime(prime + 1) && IsTetraPrime(prime + 2))
            {
                tetrasFollowing.Add(prime);
                if ((prime + 1) % 7 == 0 || (prime + 2) % 7 == 0)
                {
                    sevensFollowing++;
                }
            }

            if (prime == largestPrime5 || prime == largestPrime6 || prime == largestPrime7)
            {
                for (int i = 0; i <= 1; i++)
                {
                    List<int> tetras = (i == 0) ? new List<int>(tetrasPreceding) : new List<int>(tetrasFollowing);
                    int size = tetras.Count;
                    int sevens = (i == 0) ? sevensPreceding : sevensFollowing;
                    string text = (i == 0) ? "preceding" : "following";

                    Console.Write("Found " + size + " primes under " + limit + " whose " + text + " neighboring pair are tetraprimes");
                    if (prime == largestPrime5)
                    {
                        Console.WriteLine(":");
                        for (int j = 0; j < size; j++)
                        {
                            Console.Write($"{tetras[j],7}{(j % 10 == 9 ? "\n" : "")}");
                        }
                        Console.WriteLine();
                    }
                    Console.WriteLine();
                    Console.WriteLine("of which " + sevens + " have a neighboring pair one of whose factors is 7.");
                    Console.WriteLine();

                    var gaps = new List<int>();
                    for (int k = 0; k < size - 1; k++)
                    {
                        gaps.Add(tetras[k + 1] - tetras[k]);
                    }
                    gaps.Sort();
                    int minimum = gaps[0];
                    int maximum = gaps[gaps.Count - 1];
                    int middle = Median(gaps);
                    Console.WriteLine("Minimum gap between those " + size + " primes: " + minimum);
                    Console.WriteLine("Median gap between those " + size + " primes: " + middle);
                    Console.WriteLine("Maximum gap between those " + size + " primes: " + maximum);
                    Console.WriteLine();
                }
                limit *= 10;
            }
        }
    }

    private static bool IsTetraPrime(int number)
    {
        int count = 0;
        int previousFactor = 1;
        foreach (var prime in primes)
        {
            int limit = prime * prime;
            if (count == 0)
            {
                limit *= limit;
            }
            else if (count == 1)
            {
                limit *= prime;
            }
            if (limit <= number)
            {
                while (number % prime == 0)
                {
                    if (count == 4 || prime == previousFactor)
                    {
                        return false;
                    }
                    count++;
                    number /= prime;
                    previousFactor = prime;
                }
            }
            else
            {
                break;
            }
        }

        if (number > 1)
        {
            if (count == 4 || number == previousFactor)
            {
                return false;
            }
            count++;
        }
        return count == 4;
    }

    private static int Median(List<int> list)
    {
        int size = list.Count;
        if (size % 2 == 0)
        {
            return (list[size / 2 - 1] + list[size / 2]) / 2;
        }
        return list[size / 2];
    }

    private static int LargestLessThan(int number)
    {
        int index = primes.BinarySearch(number);
        if (index > 0)
        {
            return primes[index - 1];
        }
        return primes[~index - 2];
    }

    private static void ListPrimeNumbers(int limit)
    {
        int halfLimit = (limit + 1) / 2;
        var composite = new bool[halfLimit];
        for (int i = 1, p = 3; i < halfLimit; p += 2, i++)
        {
            if (!composite[i])
            {
                for (int j = i + p; j < halfLimit; j += p)
                {
                    composite[j] = true;
                }
            }
        }

        primes = new List<int> { 2 };
        for (int i = 1, p = 3; i < halfLimit; p += 2, i++)
        {
            if (!composite[i])
            {
                primes.Add(p);
            }
        }
    }
}
