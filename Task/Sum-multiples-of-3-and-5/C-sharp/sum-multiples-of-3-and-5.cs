using System;
using System.Collections.Generic;
using System.Numerics;

namespace RosettaCode
{
    class Program
    {
        static void Main()
        {
            List<BigInteger> candidates = new List<BigInteger>(new BigInteger[] { 1000, 100000, 10000000, 10000000000, 1000000000000000 });
            candidates.Add(BigInteger.Parse("100000000000000000000"));

            foreach (BigInteger candidate in candidates)
            {
                BigInteger c = candidate - 1;
                BigInteger answer3 = GetSumOfNumbersDivisibleByN(c, 3);
                BigInteger answer5 = GetSumOfNumbersDivisibleByN(c, 5);
                BigInteger answer15 = GetSumOfNumbersDivisibleByN(c, 15);

                Console.WriteLine("The sum of numbers divisible by 3 or 5 between 1 and {0} is {1}", c, answer3 + answer5 - answer15);
            }

            Console.ReadKey(true);
        }

        private static BigInteger GetSumOfNumbersDivisibleByN(BigInteger candidate, uint n)
        {
            BigInteger largest = candidate;
            while (largest % n > 0)
                largest--;
            BigInteger totalCount = (largest / n);
            BigInteger pairCount = totalCount / 2;
            bool unpairedNumberOnFoldLine = (totalCount % 2 == 1);
            BigInteger pairSum = largest + n;
            return pairCount * pairSum + (unpairedNumberOnFoldLine ? pairSum / 2 : 0);
        }

    }
}
