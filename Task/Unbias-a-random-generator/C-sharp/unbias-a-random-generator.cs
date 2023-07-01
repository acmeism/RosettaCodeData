using System;

namespace Unbias
{
    internal class Program
    {
        private static void Main(string[] args)
        {
            // Demonstrate.
            for (int n = 3; n <= 6; n++)
            {
                int biasedZero = 0, biasedOne = 0, unbiasedZero = 0, unbiasedOne = 0;
                for (int i = 0; i < 100000; i++)
                {
                    if (randN(n))
                        biasedOne++;
                    else
                        biasedZero++;
                    if (Unbiased(n))
                        unbiasedOne++;
                    else
                        unbiasedZero++;
                }

                Console.WriteLine("(N = {0}):".PadRight(17) + "# of 0\t# of 1\t% of 0\t% of 1", n);
                Console.WriteLine("Biased:".PadRight(15) + "{0}\t{1}\t{2}\t{3}",
                                  biasedZero, biasedOne,
                                  biasedZero/1000, biasedOne/1000);
                Console.WriteLine("Unbiased:".PadRight(15) + "{0}\t{1}\t{2}\t{3}",
                                  unbiasedZero, unbiasedOne,
                                  unbiasedZero/1000, unbiasedOne/1000);
            }
        }

        private static bool Unbiased(int n)
        {
            bool flip1, flip2;

            /* Flip twice, and check if the values are the same.
             * If so, flip again. Otherwise, return the value of the first flip. */

            do
            {
                flip1 = randN(n);
                flip2 = randN(n);
            } while (flip1 == flip2);

            return flip1;
        }

        private static readonly Random random = new Random();

        private static bool randN(int n)
        {
            // Has an 1/n chance of returning 1. Otherwise it returns 0.
            return random.Next(0, n) == 0;
        }
    }
}
