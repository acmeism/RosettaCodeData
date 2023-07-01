using System;

namespace PrimeConspiracy {
    class Program {
        static void Main(string[] args) {
            const int limit = 1_000_000;
            const int sieveLimit = 15_500_000;

            int[,] buckets = new int[10, 10];
            int prevDigit = 2;
            bool[] notPrime = Sieve(sieveLimit);

            for (int n = 3, primeCount = 1; primeCount < limit; n++) {
                if (notPrime[n]) continue;

                int digit = n % 10;
                buckets[prevDigit, digit]++;
                prevDigit = digit;
                primeCount++;
            }

            for (int i = 0; i < 10; i++) {
                for (int j = 0; j < 10; j++) {
                    if (buckets[i, j] != 0) {
                        Console.WriteLine("{0} -> {1}  count: {2,5:d}  frequency : {3,6:0.00%}", i, j, buckets[i, j], 1.0 * buckets[i, j] / limit);
                    }
                }
            }
        }

        public static bool[] Sieve(int limit) {
            bool[] composite = new bool[limit];
            composite[0] = composite[1] = true;

            int max = (int)Math.Sqrt(limit);
            for (int n = 2; n <= max; n++) {
                if (!composite[n]) {
                    for (int k = n * n; k < limit; k += n) {
                        composite[k] = true;
                    }
                }
            }

            return composite;
        }
    }
}
