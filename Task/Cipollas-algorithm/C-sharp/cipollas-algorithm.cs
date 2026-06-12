using System;
using System.Numerics;

namespace CipollaAlgorithm {
    class Program {
        static readonly BigInteger BIG = BigInteger.Pow(10, 50) + 151;

        private static Tuple<BigInteger, BigInteger, bool> C(string ns, string ps) {
            BigInteger n = BigInteger.Parse(ns);
            BigInteger p = ps.Length > 0 ? BigInteger.Parse(ps) : BIG;

            // Legendre symbol. Returns 1, 0, or p-1
            BigInteger ls(BigInteger a0) => BigInteger.ModPow(a0, (p - 1) / 2, p);

            // Step 0: validate arguments
            if (ls(n) != 1) {
                return new Tuple<BigInteger, BigInteger, bool>(0, 0, false);
            }

            // Step 1: Find a, omega2
            BigInteger a = 0;
            BigInteger omega2;
            while (true) {
                omega2 = (a * a + p - n) % p;
                if (ls(omega2) == p - 1) {
                    break;
                }
                a += 1;
            }

            // Multiplication in Fp2
            BigInteger finalOmega = omega2;
            Tuple<BigInteger, BigInteger> mul(Tuple<BigInteger, BigInteger> aa, Tuple<BigInteger, BigInteger> bb) {
                return new Tuple<BigInteger, BigInteger>(
                    (aa.Item1 * bb.Item1 + aa.Item2 * bb.Item2 * finalOmega) % p,
                    (aa.Item1 * bb.Item2 + bb.Item1 * aa.Item2) % p
                );
            }

            // Step 2: Compute power
            Tuple<BigInteger, BigInteger> r = new Tuple<BigInteger, BigInteger>(1, 0);
            Tuple<BigInteger, BigInteger> s = new Tuple<BigInteger, BigInteger>(a, 1);
            BigInteger nn = ((p + 1) >> 1) % p;
            while (nn > 0) {
                if ((nn & 1) == 1) {
                    r = mul(r, s);
                }
                s = mul(s, s);
                nn >>= 1;
            }

            // Step 3: Check x in Fp
            if (r.Item2 != 0) {
                return new Tuple<BigInteger, BigInteger, bool>(0, 0, false);
            }

            // Step 5: Check x * x = n
            if (r.Item1 * r.Item1 % p != n) {
                return new Tuple<BigInteger, BigInteger, bool>(0, 0, false);
            }

            // Step 4: Solutions
            return new Tuple<BigInteger, BigInteger, bool>(r.Item1, p - r.Item1, true);
        }

        static void Main(string[] args) {
            Console.WriteLine(C("10", "13"));
            Console.WriteLine(C("56", "101"));
            Console.WriteLine(C("8218", "10007"));
            Console.WriteLine(C("8219", "10007"));
            Console.WriteLine(C("331575", "1000003"));
            Console.WriteLine(C("665165880", "1000000007"));
            Console.WriteLine(C("881398088036", "1000000000039"));
            Console.WriteLine(C("34035243914635549601583369544560650254325084643201", ""));
        }
    }
}
