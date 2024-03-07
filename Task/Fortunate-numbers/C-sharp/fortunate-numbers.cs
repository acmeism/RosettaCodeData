using System;
using System.Collections.Generic;
using System.Numerics;

public class FortunateNumbers
{
    private const int CERTAINTY_LEVEL = 10;

    public static void Main(string[] args)
    {
        var primes = PrimeSieve(400);
        SortedSet<int> fortunates = new SortedSet<int>();
        BigInteger primorial = BigInteger.One;

        foreach (var prime in primes)
        {
            primorial *= prime;
            int candidate = 3;
            while (!BigInteger.Add(primorial, candidate).IsProbablyPrime(CERTAINTY_LEVEL))
            {
                candidate += 2;
            }
            fortunates.Add(candidate);
        }

        Console.WriteLine("The first 50 distinct fortunate numbers are:");
        int count = 0;
        foreach (var fortunate in fortunates)
        {
            if (count >= 50) break;
            Console.Write($"{fortunate,4}{(count % 10 == 9 ? "\n" : "")}");
            count++;
        }
    }

    private static List<int> PrimeSieve(int aNumber)
    {
        var sieve = new bool[aNumber + 1];
        var primes = new List<int>();

        for (int i = 2; i <= aNumber; i++)
        {
            if (!sieve[i])
            {
                primes.Add(i);
                for (int j = i * i; j <= aNumber && j > 0; j += i)
                {
                    sieve[j] = true;
                }
            }
        }
        return primes;
    }
}

public static class BigIntegerExtensions
{
    private static Random random = new Random();

    public static bool IsProbablyPrime(this BigInteger source, int certainty)
    {
        if (source == 2 || source == 3)
            return true;
        if (source < 2 || source % 2 == 0)
            return false;

        BigInteger d = source - 1;
        int s = 0;

        while (d % 2 == 0)
        {
            d /= 2;
            s += 1;
        }

        for (int i = 0; i < certainty; i++)
        {
            BigInteger a = RandomBigInteger(2, source - 2);
            BigInteger x = BigInteger.ModPow(a, d, source);
            if (x == 1 || x == source - 1)
                continue;

            for (int r = 1; r < s; r++)
            {
                x = BigInteger.ModPow(x, 2, source);
                if (x == 1)
                    return false;
                if (x == source - 1)
                    break;
            }

            if (x != source - 1)
                return false;
        }

        return true;
    }

    private static BigInteger RandomBigInteger(BigInteger minValue, BigInteger maxValue)
    {
        if (minValue > maxValue)
            throw new ArgumentException("minValue must be less than or equal to maxValue");

        BigInteger range = maxValue - minValue + 1;
        int length = range.ToByteArray().Length;
        byte[] buffer = new byte[length];

        BigInteger result;
        do
        {
            random.NextBytes(buffer);
            buffer[buffer.Length - 1] &= 0x7F; // Ensure non-negative
            result = new BigInteger(buffer);
        } while (result < minValue || result >= maxValue);

        return result;
    }
}
