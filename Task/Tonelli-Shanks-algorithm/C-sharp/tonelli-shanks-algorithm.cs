using System;
using System.Collections.Generic;
using System.Numerics;

namespace TonelliShanks {
    class Solution {
        private readonly BigInteger root1, root2;
        private readonly bool exists;

        public Solution(BigInteger root1, BigInteger root2, bool exists) {
            this.root1 = root1;
            this.root2 = root2;
            this.exists = exists;
        }

        public BigInteger Root1() {
            return root1;
        }

        public BigInteger Root2() {
            return root2;
        }

        public bool Exists() {
            return exists;
        }
    }

    class Program {
        static Solution Ts(BigInteger n, BigInteger p) {
            if (BigInteger.ModPow(n, (p - 1) / 2, p) != 1) {
                return new Solution(0, 0, false);
            }

            BigInteger q = p - 1;
            BigInteger ss = 0;
            while ((q & 1) == 0) {
                ss = ss + 1;
                q = q >> 1;
            }

            if (ss == 1) {
                BigInteger r1 = BigInteger.ModPow(n, (p + 1) / 4, p);
                return new Solution(r1, p - r1, true);
            }

            BigInteger z = 2;
            while (BigInteger.ModPow(z, (p - 1) / 2, p) != p - 1) {
                z = z + 1;
            }
            BigInteger c = BigInteger.ModPow(z, q, p);
            BigInteger r = BigInteger.ModPow(n, (q + 1) / 2, p);
            BigInteger t = BigInteger.ModPow(n, q, p);
            BigInteger m = ss;

            while (true) {
                if (t == 1) {
                    return new Solution(r, p - r, true);
                }
                BigInteger i = 0;
                BigInteger zz = t;
                while (zz != 1 && i < (m - 1)) {
                    zz = zz * zz % p;
                    i = i + 1;
                }
                BigInteger b = c;
                BigInteger e = m - i - 1;
                while (e > 0) {
                    b = b * b % p;
                    e = e - 1;
                }
                r = r * b % p;
                c = b * b % p;
                t = t * c % p;
                m = i;
            }
        }

        static void Main(string[] args) {
            List<Tuple<long, long>> pairs = new List<Tuple<long, long>>() {
                new Tuple<long, long>(10, 13),
                new Tuple<long, long>(56, 101),
                new Tuple<long, long>(1030, 10009),
                new Tuple<long, long>(1032, 10009),
                new Tuple<long, long>(44402, 100049),
                new Tuple<long, long>(665820697, 1000000009),
                new Tuple<long, long>(881398088036, 1000000000039),
            };

            foreach (var pair in pairs) {
                Solution sol = Ts(pair.Item1, pair.Item2);
                Console.WriteLine("n = {0}", pair.Item1);
                Console.WriteLine("p = {0}", pair.Item2);
                if (sol.Exists()) {
                    Console.WriteLine("root1 = {0}", sol.Root1());
                    Console.WriteLine("root2 = {0}", sol.Root2());
                } else {
                    Console.WriteLine("No solution exists");
                }
                Console.WriteLine();
            }

            BigInteger bn = BigInteger.Parse("41660815127637347468140745042827704103445750172002");
            BigInteger bp = BigInteger.Pow(10, 50) + 577;
            Solution bsol = Ts(bn, bp);
            Console.WriteLine("n = {0}", bn);
            Console.WriteLine("p = {0}", bp);
            if (bsol.Exists()) {
                Console.WriteLine("root1 = {0}", bsol.Root1());
                Console.WriteLine("root2 = {0}", bsol.Root2());
            } else {
                Console.WriteLine("No solution exists");
            }
        }
    }
}
