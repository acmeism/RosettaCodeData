using System;
using System.Linq;

namespace PerniciousNumbers
{
    class Program
    {
        public static int PopulationCount(long n)
        {
            int cnt = 0;
            do
            {
                if ((n & 1) != 0)
                {
                    cnt++;
                }
            } while ((n >>= 1) > 0);

            return cnt;
        }

         public static bool isPrime(int x)
        {
            if (x <= 2 || (x & 1) == 0)
            {
                return x == 2;
            }

            var limit = Math.Sqrt(x);
            for (int i = 3; i <= limit; i += 2)
            {
                if (x % i == 0)
                {
                    return false;
                }
            }

            return true;
        }

        private static IEnumerable<int> Pernicious(int start, int count, int take)
        {
            return Enumerable.Range(start, count).Where(n => isPrime(PopulationCount(n))).Take(take);
        }

        static void Main(string[] args)
        {
            foreach (var n in Pernicious(0, int.MaxValue, 25))
            {
                Console.Write("{0} ", n);
            }

            Console.WriteLine();

            foreach (var n in Pernicious(888888877, 11, 11))
            {
                Console.Write("{0} ", n);
            }

            Console.ReadKey();
        }
    }
}
