using System;
using System.Collections.Generic;
using System.Linq;

namespace WieferichPrimes {
    class Program {
        static long ModPow(long @base, long exp, long mod) {
            if (mod == 1) {
                return 0;
            }

            long result = 1;
            @base %= mod;
            for (; exp > 0; exp >>= 1) {
                if ((exp & 1) == 1) {
                    result = (result * @base) % mod;
                }
                @base = (@base * @base) % mod;
            }
            return result;
        }

        static bool[] PrimeSieve(int limit) {
            bool[] sieve = Enumerable.Repeat(true, limit).ToArray();

            if (limit > 0) {
                sieve[0] = false;
            }
            if (limit > 1) {
                sieve[1] = false;
            }

            for (int i = 4; i < limit; i += 2) {
                sieve[i] = false;
            }

            for (int p = 3; ; p += 2) {
                int q = p * p;
                if (q >= limit) {
                    break;
                }
                if (sieve[p]) {
                    int inc = 2 * p;
                    for (; q < limit; q += inc) {
                        sieve[q] = false;
                    }
                }
            }

            return sieve;
        }

        static List<int> WiefreichPrimes(int limit) {
            bool[] sieve = PrimeSieve(limit);
            List<int> result = new List<int>();
            for (int p = 2; p < limit; p++) {
                if (sieve[p] && ModPow(2, p - 1, p * p) == 1) {
                    result.Add(p);
                }
            }
            return result;
        }

        static void Main() {
            const int limit = 5000;
            Console.WriteLine("Wieferich primes less that {0}:", limit);
            foreach (int p in WiefreichPrimes(limit)) {
                Console.WriteLine(p);
            }
        }
    }
}
