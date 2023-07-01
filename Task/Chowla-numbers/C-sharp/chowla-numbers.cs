using System;

namespace chowla_cs
{
    class Program
    {
        static int chowla(int n)
        {
            int sum = 0;
            for (int i = 2, j; i * i <= n; i++)
                if (n % i == 0) sum += i + (i == (j = n / i) ? 0 : j);
            return sum;
        }

        static bool[] sieve(int limit)
        {
            // True denotes composite, false denotes prime.
            // Only interested in odd numbers >= 3
            bool[] c = new bool[limit];
            for (int i = 3; i * 3 < limit; i += 2)
                if (!c[i] && (chowla(i) == 0))
                    for (int j = 3 * i; j < limit; j += 2 * i)
                        c[j] = true;
            return c;
        }

        static void Main(string[] args)
        {
            for (int i = 1; i <= 37; i++)
                Console.WriteLine("chowla({0}) = {1}", i, chowla(i));
            int count = 1, limit = (int)(1e7), power = 100;
            bool[] c = sieve(limit);
            for (int i = 3; i < limit; i += 2)
            {
                if (!c[i]) count++;
                if (i == power - 1)
                {
                    Console.WriteLine("Count of primes up to {0,10:n0} = {1:n0}", power, count);
                    power *= 10;
                }
            }

            count = 0; limit = 35000000;
            int k = 2, kk = 3, p;
            for (int i = 2; ; i++)
            {
                if ((p = k * kk) > limit) break;
                if (chowla(p) == p - 1)
                {
                    Console.WriteLine("{0,10:n0} is a number that is perfect", p);
                    count++;
                }
                k = kk + 1; kk += k;
            }
            Console.WriteLine("There are {0} perfect numbers <= 35,000,000", count);
            if (System.Diagnostics.Debugger.IsAttached) Console.ReadKey();
        }
    }
}
