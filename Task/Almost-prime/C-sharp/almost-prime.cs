using System;
using System.Collections.Generic;
using System.Linq;

namespace AlmostPrime
{
    class Program
    {
        static void Main(string[] args)
        {
            foreach (int k in Enumerable.Range(1, 5))
            {
                KPrime kprime = new KPrime() { K = k };
                Console.WriteLine("k = {0}: {1}",
                    k, string.Join<int>(" ", kprime.GetFirstN(10)));
            }
        }
    }

    class KPrime
    {
        public int K { get; set; }

        public bool IsKPrime(int number)
        {
            int primes = 0;
            for (int p = 2; p * p <= number && primes < K; ++p)
            {
                while (number % p == 0 && primes < K)
                {
                    number /= p;
                    ++primes;
                }
            }
            if (number > 1)
            {
                ++primes;
            }
            return primes == K;
        }

        public List<int> GetFirstN(int n)
        {
            List<int> result = new List<int>();
            for (int number = 2; result.Count < n; ++number)
            {
                if (IsKPrime(number))
                {
                    result.Add(number);
                }
            }
            return result;
        }
    }
}
