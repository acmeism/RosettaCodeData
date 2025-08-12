using System;

namespace MobiusDemo
{
    class Program
    {
        // -----------------------------------------------------------------
        //  Settings that are identical to the Java version
        // -----------------------------------------------------------------
        private const int MU_MAX = 1_000_000;   // same upper bound
        private static int[] MU = null;        // will hold the sieve

        static void Main(string[] args)
        {
            Console.WriteLine("First 199 terms of the möbius function are as follows:");
            Console.Write("    ");

            for (int n = 1; n < 200; n++)
            {
                Console.Write($"{MobiusFunction(n),2}  ");

                // line‑break after every 20 numbers – exactly like the Java code
                if ((n + 1) % 20 == 0)
                    Console.WriteLine();
            }
        }

        // -----------------------------------------------------------------
        //  Compute μ(n) using the same sieve algorithm that the Java code
        //  uses. The first call builds the whole table up to MU_MAX.
        // -----------------------------------------------------------------
        private static int MobiusFunction(int n)
        {
            // If the sieve has already been built we can return the answer
            // straight away.
            if (MU != null)
                return MU[n];

            // -------------------------------------------------------------
            //  Build the sieve (once)
            // -------------------------------------------------------------
            MU = new int[MU_MAX + 1];

            // initialise every entry with 1 – Java did this explicitly
            for (int i = 0; i <= MU_MAX; i++)
                MU[i] = 1;

            int sqrt = (int)Math.Sqrt(MU_MAX);

            // first pass: multiply by -p for each prime factor p,
            // and mark multiples of p² as zero.
            for (int i = 2; i <= sqrt; i++)
            {
                if (MU[i] == 1)                // i is still “prime”
                {
                    // flip the sign for every multiple of i
                    for (int j = i; j <= MU_MAX; j += i)
                        MU[j] *= -i;

                    // any number that contains i² gets value 0
                    int i2 = i * i;
                    for (int j = i2; j <= MU_MAX; j += i2)
                        MU[j] = 0;
                }
            }

            // second pass: reduce the encoded values to the final μ(n)
            for (int i = 2; i <= MU_MAX; i++)
            {
                if (MU[i] == i)          // only +i  => μ = +1
                    MU[i] = 1;
                else if (MU[i] == -i)    // only -i  => μ = -1
                    MU[i] = -1;
                else if (MU[i] < 0)      // product of an odd number of distinct primes
                    MU[i] = 1;
                else if (MU[i] > 0)      // product of an even number of distinct primes
                    MU[i] = -1;
                // note: MU[i] == 0 stays 0 (square factor present)
            }

            return MU[n];
        }
    }
}
