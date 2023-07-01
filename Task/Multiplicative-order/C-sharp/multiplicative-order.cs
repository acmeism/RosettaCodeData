using System;
using System.Collections.Generic;
using System.Numerics;
using System.Threading;

namespace MultiplicativeOrder {
    // Taken from https://stackoverflow.com/a/33918233
    public static class PrimeExtensions {
        // Random generator (thread safe)
        private static ThreadLocal<Random> s_Gen = new ThreadLocal<Random>(
          () => {
              return new Random();
          }
        );

        // Random generator (thread safe)
        private static Random Gen {
            get {
                return s_Gen.Value;
            }
        }

        public static bool IsProbablyPrime(this BigInteger value, int witnesses = 10) {
            if (value <= 1)
                return false;

            if (witnesses <= 0)
                witnesses = 10;

            BigInteger d = value - 1;
            int s = 0;

            while (d % 2 == 0) {
                d /= 2;
                s += 1;
            }

            byte[] bytes = new byte[value.ToByteArray().LongLength];
            BigInteger a;

            for (int i = 0; i < witnesses; i++) {
                do {
                    Gen.NextBytes(bytes);

                    a = new BigInteger(bytes);
                }
                while (a < 2 || a >= value - 2);

                BigInteger x = BigInteger.ModPow(a, d, value);
                if (x == 1 || x == value - 1)
                    continue;

                for (int r = 1; r < s; r++) {
                    x = BigInteger.ModPow(x, 2, value);

                    if (x == 1)
                        return false;
                    if (x == value - 1)
                        break;
                }

                if (x != value - 1)
                    return false;
            }

            return true;
        }
    }

    static class Helper {
        public static BigInteger Sqrt(this BigInteger self) {
            BigInteger b = self;
            while (true) {
                BigInteger a = b;
                b = self / a + a >> 1;
                if (b >= a) return a;
            }
        }

        public static long BitLength(this BigInteger self) {
            BigInteger bi = self;
            long bitlength = 0;
            while (bi != 0) {
                bitlength++;
                bi >>= 1;
            }
            return bitlength;
        }

        public static bool BitTest(this BigInteger self, int pos) {
            byte[] arr = self.ToByteArray();
            int idx = pos / 8;
            int mod = pos % 8;
            if (idx >= arr.Length) {
                return false;
            }
            return (arr[idx] & (1 << mod)) > 0;
        }
    }

    class PExp {
        public PExp(BigInteger prime, int exp) {
            Prime = prime;
            Exp = exp;
        }

        public BigInteger Prime { get; }

        public int Exp { get; }
    }

    class Program {
        static void MoTest(BigInteger a, BigInteger n) {
            if (!n.IsProbablyPrime(20)) {
                Console.WriteLine("Not computed. Modulus must be prime for this algorithm.");
                return;
            }
            if (a.BitLength() < 100) {
                Console.Write("ord({0})", a);
            } else {
                Console.Write("ord([big])");
            }
            if (n.BitLength() < 100) {
                Console.Write(" mod {0} ", n);
            } else {
                Console.Write(" mod [big] ");
            }
            BigInteger mob = MoBachShallit58(a, n, Factor(n - 1));
            Console.WriteLine("= {0}", mob);
        }

        static BigInteger MoBachShallit58(BigInteger a, BigInteger n, List<PExp> pf) {
            BigInteger n1 = n - 1;
            BigInteger mo = 1;
            foreach (PExp pe in pf) {
                BigInteger y = n1 / BigInteger.Pow(pe.Prime, pe.Exp);
                int o = 0;
                BigInteger x = BigInteger.ModPow(a, y, BigInteger.Abs(n));
                while (x > 1) {
                    x = BigInteger.ModPow(x, pe.Prime, BigInteger.Abs(n));
                    o++;
                }
                BigInteger o1 = BigInteger.Pow(pe.Prime, o);
                o1 = o1 / BigInteger.GreatestCommonDivisor(mo, o1);
                mo = mo * o1;
            }
            return mo;
        }

        static List<PExp> Factor(BigInteger n) {
            List<PExp> pf = new List<PExp>();
            BigInteger nn = n;
            int e = 0;
            while (!nn.BitTest(e)) e++;
            if (e > 0) {
                nn = nn >> e;
                pf.Add(new PExp(2, e));
            }
            BigInteger s = nn.Sqrt();
            BigInteger d = 3;
            while (nn > 1) {
                if (d > s) d = nn;
                e = 0;
                while (true) {
                    BigInteger div = BigInteger.DivRem(nn, d, out BigInteger rem);
                    if (rem.BitLength() > 0) break;
                    nn = div;
                    e++;
                }
                if (e > 0) {
                    pf.Add(new PExp(d, e));
                    s = nn.Sqrt();
                }
                d = d + 2;
            }

            return pf;
        }

        static void Main(string[] args) {
            MoTest(37, 3343);
            MoTest(BigInteger.Pow(10, 100) + 1, 7919);
            MoTest(BigInteger.Pow(10, 1000) + 1, 15485863);
            MoTest(BigInteger.Pow(10, 10000) - 1, 22801763489);
            MoTest(1511678068, 7379191741);
            MoTest(3047753288, 2257683301);
        }
    }
}
