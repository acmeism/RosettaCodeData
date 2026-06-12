using System;
using System.Numerics;

namespace MersennePrimes {
    class Program {
        static BigInteger Sqrt(BigInteger x) {
            if (x < 0) throw new ArgumentException("Negative argument.");
            if (x < 2) return x;
            BigInteger y = x / 2;
            while (y > x / y) {
                y = ((x / y) + y) / 2;
            }
            return y;
        }

        static bool IsPrime(BigInteger bi) {
            if (bi < 2) return false;
            if (bi % 2 == 0) return bi == 2;
            if (bi % 3 == 0) return bi == 3;
            if (bi % 5 == 0) return bi == 5;
            if (bi % 7 == 0) return bi == 7;
            if (bi % 11 == 0) return bi == 11;
            if (bi % 13 == 0) return bi == 13;
            if (bi % 17 == 0) return bi == 17;
            if (bi % 19 == 0) return bi == 19;

            BigInteger limit = Sqrt(bi);
            BigInteger test = 23;
            while (test < limit) {
                if (bi % test == 0) return false;
                test += 2;
                if (bi % test == 0) return false;
                test += 4;
            }

            return true;
        }

        static void Main(string[] args) {
            const int MAX = 9;

            int pow = 2;
            int count = 0;

            while (true) {
                if (IsPrime(pow)) {
                    BigInteger p = BigInteger.Pow(2, pow) - 1;
                    if (IsPrime(p)) {
                        Console.WriteLine("2 ^ {0} - 1", pow);
                        if (++count >= MAX) {
                            break;
                        }
                    }
                }
                pow++;
            }
        }
    }
}
