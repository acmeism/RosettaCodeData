using System;
using System.Collections.Generic;
using System.Numerics;

namespace PierpontPrimes {
    public static class Helper {
        private static readonly Random rand = new Random();
        private static readonly List<int> primeList = new List<int>() {
              2,   3,   5,   7,  11,  13,  17,  19,  23,  29,  31,  37,  41,  43, 47,
             53,  59,  61,  67,  71,  73,  79,  83,  89,  97, 101, 103, 107, 109, 113,
            127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197,
            199, 211, 223, 227, 229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281,
            283, 293, 307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 379,
            383, 389, 397, 401, 409, 419, 421, 431, 433, 439, 443, 449, 457, 461, 463,
            467, 479, 487, 491, 499, 503, 509, 521, 523, 541, 547, 557, 563, 569, 571,
            577, 587, 593, 599, 601, 607, 613, 617, 619, 631, 641, 643, 647, 653, 659,
            661, 673, 677, 683, 691, 701, 709, 719, 727, 733, 739, 743, 751, 757, 761,
            769, 773, 787, 797, 809, 811, 821, 823, 827, 829, 839, 853, 857, 859, 863,
            877, 881, 883, 887, 907, 911, 919, 929, 937, 941, 947, 953, 967, 971, 977,
        };

        public static BigInteger GetRandom(BigInteger min, BigInteger max) {
            var bytes = max.ToByteArray();
            BigInteger r;

            do {
                rand.NextBytes(bytes);
                bytes[bytes.Length - 1] &= (byte)0x7F; // force sign bit to positive
                r = new BigInteger(bytes);
            } while (r < min || r >= max);

            return r;
        }

        //Modified from https://rosettacode.org/wiki/Miller-Rabin_primality_test#Python
        public static bool IsProbablePrime(this BigInteger n) {
            if (n == 0 || n == 1) {
                return false;
            }

            bool Check(BigInteger num) {
                foreach (var prime in primeList) {
                    if (num == prime) {
                        return true;
                    }
                    if (num % prime == 0) {
                        return false;
                    }
                    if (prime * prime > num) {
                        return true;
                    }
                }

                return true;
            }

            if (Check(n)) {
                var large = primeList[primeList.Count - 1];
                if (n <= large) {
                    return true;
                }
            }

            var s = 0;
            var d = n - 1;
            while (d.IsEven) {
                d >>= 1;
                s++;
            }

            bool TrialComposite(BigInteger a) {
                if (BigInteger.ModPow(a, d, n) == 1) {
                    return false;
                }
                for (int i = 0; i < s; i++) {
                    var t = BigInteger.Pow(2, i);
                    if (BigInteger.ModPow(a, t * d, n) == n - 1) {
                        return false;
                    }
                }
                return true;
            }

            for (int i = 0; i < 8; i++) {
                var a = GetRandom(2, n);
                if (TrialComposite(a)) {
                    return false;
                }
            }
            return true;
        }
    }

    class Program {
        static List<List<BigInteger>> Pierpont(int n) {
            var p = new List<List<BigInteger>> {
                new List<BigInteger>(),
                new List<BigInteger>()
            };
            for (int i = 0; i < n; i++) {
                p[0].Add(0);
                p[1].Add(0);
            }
            p[0][0] = 2;

            var count = 0;
            var count1 = 1;
            var count2 = 0;
            List<BigInteger> s = new List<BigInteger> { 1 };
            var i2 = 0;
            var i3 = 0;
            var k = 1;
            BigInteger n2;
            BigInteger n3;
            BigInteger t;

            while (count < n) {
                n2 = s[i2] * 2;
                n3 = s[i3] * 3;
                if (n2 < n3) {
                    t = n2;
                    i2++;
                } else {
                    t = n3;
                    i3++;
                }
                if (t > s[k - 1]) {
                    s.Add(t);
                    k++;
                    t += 1;
                    if (count1 < n && t.IsProbablePrime()) {
                        p[0][count1] = t;
                        count1++;
                    }
                    t -= 2;
                    if (count2 < n && t.IsProbablePrime()) {
                        p[1][count2] = t;
                        count2++;
                    }
                    count = Math.Min(count1, count2);
                }
            }

            return p;
        }

        static void Main() {
            var p = Pierpont(250);

            Console.WriteLine("First 50 Pierpont primes of the first kind:");
            for (int i = 0; i < 50; i++) {
                Console.Write("{0,8} ", p[0][i]);
                if ((i - 9) % 10 == 0) {
                    Console.WriteLine();
                }
            }
            Console.WriteLine();

            Console.WriteLine("First 50 Pierpont primes of the second kind:");
            for (int i = 0; i < 50; i++) {
                Console.Write("{0,8} ", p[1][i]);
                if ((i - 9) % 10 == 0) {
                    Console.WriteLine();
                }
            }
            Console.WriteLine();

            Console.WriteLine("250th Pierpont prime of the first kind: {0}", p[0][249]);
            Console.WriteLine("250th Pierpont prime of the second kind: {0}", p[1][249]);
            Console.WriteLine();
        }
    }
}
