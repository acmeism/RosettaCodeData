using System;
using System.Collections.Generic;
using System.Linq;

public class Anaprimes
{
    public static void Main(string[] args)
    {
        List<int> primes = ListPrimeNumbers(1_000_001_000);
        Dictionary<List<int>, List<int>> anaprimes = new Dictionary<List<int>, List<int>>(new ListComparer());

        int index = 0;
        int limit = 1_000;
        while (limit <= 1_000_000_000)
        {
            int prime = primes[index++];
            if (prime > limit)
            {
                int maxLength = 0;
                List<List<int>> groups = new List<List<int>>();
                foreach (List<int> value in anaprimes.Values)
                {
                    if (value.Count > maxLength)
                    {
                        groups.Clear();
                        maxLength = value.Count;
                    }
                    if (value.Count == maxLength)
                    {
                        groups.Add(value);
                    }
                }

                Console.WriteLine(
                    $"Largest group(s) of anaprimes less than {limit} has {maxLength} members:");
                foreach (List<int> group in groups)
                {
                    Console.WriteLine($"    First: {group.First()}, Last: {group.Last()}");
                }
                Console.WriteLine();
                anaprimes.Clear();
                limit *= 10;
            }

            List<int> key = Digits(prime);
            if (!anaprimes.ContainsKey(key))
            {
                anaprimes[key] = new List<int>();
            }
            anaprimes[key].Add(prime);
        }
    }

    private static List<int> Digits(int number)
    {
        List<int> result = new List<int>();
        while (number > 0)
        {
            result.Add(number % 10);
            number /= 10;
        }
        result.Sort();
        return result;
    }

    private static List<int> ListPrimeNumbers(int limit)
    {
        List<int> primes = new List<int>();
        primes.Add(2);
        int halfLimit = (limit + 1) / 2;
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
        return primes;
    }

    // Custom comparer for List<int> to use as dictionary key
    private class ListComparer : IEqualityComparer<List<int>>
    {
        public bool Equals(List<int> x, List<int> y)
        {
            if (x == null || y == null)
                return x == y;
            return x.SequenceEqual(y);
        }

        public int GetHashCode(List<int> obj)
        {
            if (obj == null)
                return 0;
            int hash = 17;
            foreach (int item in obj)
            {
                hash = hash * 31 + item.GetHashCode();
            }
            return hash;
        }
    }
}
