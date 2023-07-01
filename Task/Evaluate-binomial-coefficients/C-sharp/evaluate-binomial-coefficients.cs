using System;

namespace BinomialCoefficients
{
    class Program
    {
        static void Main(string[] args)
        {
            ulong n = 1000000, k = 3;
            ulong result = biCoefficient(n, k);
            Console.WriteLine("The Binomial Coefficient of {0}, and {1}, is equal to: {2}", n, k, result);
            Console.ReadLine();
        }

        static int fact(int n)
        {
            if (n == 0) return 1;
            else return n * fact(n - 1);
        }

        static ulong biCoefficient(ulong n, ulong k)
        {
            if (k > n - k)
            {
                k = n - k;
            }

            ulong c = 1;
            for (uint i = 0; i < k; i++)
            {
                c = c * (n - i);
                c = c / (i + 1);
            }
            return c;
        }
    }
}
