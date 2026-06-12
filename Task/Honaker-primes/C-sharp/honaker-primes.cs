using System;
using System.Collections.Generic;
using System.Linq;

public class HonakerPrimes
{
    private static List<int> primes = new List<int>();
    private static int honakerIndex = 0;
    private static int primeIndex = 0;

    public static void Main(string[] args)
    {
        SievePrimes(5_000_000);

        Console.WriteLine("The first 50 Honaker primes (honaker index: prime index, prime):");
        for (int i = 1; i <= 50; i++)
        {
            Console.Write($"{NextHonakerPrime()}{(i % 5 == 0 ? "\n" : " ")}");
        }
        for (int i = 51; i < 10_000; i++)
        {
            NextHonakerPrime();
        }
        Console.WriteLine();
        Console.WriteLine($"The 10,000th Honaker prime is: {NextHonakerPrime()}");
    }

    private static HonakerPrime NextHonakerPrime()
    {
        honakerIndex++;
        primeIndex++;
        while (DigitalSum(primeIndex) != DigitalSum(primes[primeIndex - 1]))
        {
            primeIndex++;
        }
        return new HonakerPrime(honakerIndex, primeIndex, primes[primeIndex - 1]);
    }

    private static int DigitalSum(int number)
    {
        return number.ToString().Select(c => c - '0').Sum();
    }

    private static void SievePrimes(int limit)
    {
        primes.Add(2);
        var halfLimit = (limit + 1) / 2;
        bool[] composite = new bool[halfLimit];
        for (int i = 1, p = 3; i < halfLimit; p += 2, i++)
        {
            if (!composite[i])
            {
                primes.Add(p);
                for (int a = i + p; a < halfLimit; a += p)
                {
                    composite[a] = true;
                }
            }
        }
    }

    private class HonakerPrime
    {
        public int HonakerIndex { get; }
        public int PrimeIndex { get; }
        public int Prime { get; }

        public HonakerPrime(int honakerIndex, int primeIndex, int prime)
        {
            HonakerIndex = honakerIndex;
            PrimeIndex = primeIndex;
            Prime = prime;
        }

        public override string ToString() => $"({HonakerIndex}: {PrimeIndex}, {Prime})";
    }
}
