using System;
using System.Collections.Generic;
using System.Numerics;
using System.Threading.Tasks;

namespace LucasLehmerTestForRosettaCode
{
    public class LucasLehmerTest
    {
        static BigInteger ZERO = new BigInteger(0);
        static BigInteger ONE = new BigInteger(1);
        static BigInteger TWO = new BigInteger(2);
        static BigInteger FOUR = new BigInteger(4);

        private static bool isMersennePrime(int p)
        {
            if (p % 2 == 0) return (p == 2);
            else {
                for (int i = 3; i <= (int)Math.Sqrt(p); i += 2)
                    if (p % i == 0) return false; //not prime
                BigInteger m_p = BigInteger.Pow(TWO, p) - ONE;
                BigInteger s = FOUR;
                for (int i = 3; i <= p; i++)
                    s = (s * s - TWO) % m_p;
                return s == ZERO;
            }
        }

        public static int[] GetMersennePrimeNumbers(int upTo)
        {
            List<int> response = new List<int>();
            Parallel.For(2, upTo + 1, i => {
                if (isMersennePrime(i)) response.Add(i);
            });
            response.Sort();
            return response.ToArray();
        }

        static void Main(string[] args)
        {
            int[] mersennePrimes = LucasLehmerTest.GetMersennePrimeNumbers(11213);
            foreach (int mp in mersennePrimes)
                Console.Write("M" + mp+" ");
            Console.ReadLine();
        }
    }
}
