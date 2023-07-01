using System;
using System.Numerics;
using System.Linq;

namespace Hamming {

    class MainClass {

        public static BigInteger[] Hamming(int n, int[] a) {
            var primes = a.Select(x => (BigInteger)x).ToArray();
            var values = a.Select(x => (BigInteger)x).ToArray();
            var indexes = new int[a.Length];
            var results = new BigInteger[n];
            results[0] = 1;
            for (int iter = 1; iter < n; iter++) {
                results[iter] = values[0];
                for (int p = 1; p < primes.Length; p++)
                    if (results[iter] > values[p])
                        results[iter] = values[p];
                for (int p = 0; p < primes.Length; p++)
                    if (results[iter] == values[p])
                        values[p] = primes[p] * results[++indexes[p]];
            }
            return results;
        }

        public static void Main(string[] args) {
            foreach (int[] primes in new int[][] { new int[] {2,3,5}, new int[] {2,3,5,7} }) {
                Console.WriteLine("{0}-Smooth:", primes.Last());
                Console.WriteLine(string.Join(" ", Hamming(20, primes)));
                Console.WriteLine(Hamming(1691, primes).Last());
                Console.WriteLine(Hamming(1000000, primes).Last());
                Console.WriteLine();
            }
        }
    }
}
