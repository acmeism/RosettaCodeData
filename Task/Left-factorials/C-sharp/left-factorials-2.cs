using System;
using System.Numerics;

namespace LeftFactorial
{
    class Program
    {
        static void Main(string[] args)
        {
            for (int i = 0; i <= 10; i++)
            {
                Console.WriteLine(string.Format("!{0} : {1}", i, LeftFactorial(i)));
            }

            for (int j = 20; j <= 110; j += 10)
            {
                Console.WriteLine(string.Format("!{0} : {1}", j, LeftFactorial(j)));
            }

            for (int k = 1000; k <= 10000; k += 1000)
            {
                Console.WriteLine(string.Format("!{0} : has {1} digits", k, LeftFactorial(k).ToString().Length));
            }

            Console.ReadKey();
        }

        private static BigInteger LeftFactorial(int n)
        {
            BigInteger result = 0;
            BigInteger subResult = 1;

            for (int i = 0; i < n; i++)
            {
                if (i == 0)
                {
                    subResult = 1;
                }
                else
                {
                    subResult *= i;
                }

                result += subResult;
            }

            return result;
        }
    }
}
