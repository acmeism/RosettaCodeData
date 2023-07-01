using System;

namespace Munchhausen
{
    class Program
    {
        static readonly long[] cache = new long[10];

        static void Main()
        {
            // Allow for 0 ^ 0 to be 0
            for (int i = 1; i < 10; i++)
            {
                cache[i] = (long)Math.Pow(i, i);
            }

            for (long i = 0L; i <= 500_000_000L; i++)
            {
                if (IsMunchhausen(i))
                {
                    Console.WriteLine(i);
                }
            }
            Console.ReadLine();
        }

        private static bool IsMunchhausen(long n)
        {
            long sum = 0, nn = n;
            do
            {
                sum += cache[(int)(nn % 10)];
                if (sum > n)
                {
                    return false;
                }
                nn /= 10;
            } while (nn > 0);

            return sum == n;
        }
    }
}
