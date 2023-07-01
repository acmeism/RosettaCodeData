using System;
using System.Linq;
using System.Numerics;

namespace HammingFast {

    class MainClass {

        private static int[] _primes = { 2, 3, 5, 7, 11, 13, 17, 19, 23, 29 };

        public static BigInteger Big(int[] exponents) {
            BigInteger val = 1;
            for (int i = 0; i < exponents.Length; i++)
                for (int e = 0; e < exponents[i]; e++)
                    val = val * _primes[i];
            return val;
        }

        public static int[] Hamming(int n, int nprimes) {
            var hammings  = new int[n, nprimes];                    // array of hamming #s we generate
            var hammlogs  = new double[n];                          // log values for above
            var primelogs = new double[nprimes];                    // pre-calculated prime log values
            var indexes   = new int[nprimes];                       // intermediate hamming values as indexes into hammings
            var listheads = new int[nprimes, nprimes];              // intermediate hamming list heads
            var listlogs  = new double[nprimes];                    // log values of list heads
            for (int p = 0; p < nprimes; p++) {
                listheads[p, p] = 1;                                // init list heads to prime values
                primelogs[p]    = Math.Log(_primes[p]);             // pre-calc prime log values
                listlogs[p]     = Math.Log(_primes[p]);             // init list head log values
            }
            for (int iter = 1; iter < n; iter++) {
                int min = 0;                                        // find index of min item in list heads
                for (int p = 1; p < nprimes; p++)
                    if (listlogs[p] < listlogs[min])
                        min = p;
                hammlogs[iter] = listlogs[min];                     // that's the next hamming number
                for (int i = 0; i < nprimes; i++)
                    hammings[iter, i] = listheads[min, i];
                for (int p = 0; p < nprimes; p++) {                 // update each list head if it matches new value
                    bool equal = true;                              // test each exponent to see if number matches
                    for (int i = 0; i < nprimes; i++) {
                        if (hammings[iter, i] != listheads[p, i]) {
                            equal = false;
                            break;
                        }
                    }
                    if (equal) {                                    // if it matches...
                        int x = ++indexes[p];                       // set index to next hamming number
                        for (int i = 0; i < nprimes; i++)           // copy each hamming exponent
                            listheads[p, i] = hammings[x, i];
                        listheads[p, p] += 1;                       // increment exponent = mult by prime
                        listlogs[p] = hammlogs[x] + primelogs[p];   // add log(prime) to log(value) = mult by prime
                    }
                }
            }

            var result = new int[nprimes];
            for (int i = 0; i < nprimes; i++)
                result[i] = hammings[n - 1, i];
            return result;
        }

        public static void Main(string[] args) {
            foreach (int np in new int[] { 3, 4, 5 }) {
                Console.WriteLine("{0}-Smooth:", _primes[np - 1]);
                Console.WriteLine(string.Join(" ", Enumerable.Range(1, 20).Select(x => Big(Hamming(x, np)))));
                Console.WriteLine(Big(Hamming(1691, np)));
                Console.WriteLine(Big(Hamming(1000000, np)));
                Console.WriteLine();
            }
        }
    }
}
