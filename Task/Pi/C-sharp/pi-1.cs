using System;
using System.Numerics;

namespace PiCalc {
    internal class Program {
        private readonly BigInteger FOUR = new BigInteger(4);
        private readonly BigInteger SEVEN = new BigInteger(7);
        private readonly BigInteger TEN = new BigInteger(10);
        private readonly BigInteger THREE = new BigInteger(3);
        private readonly BigInteger TWO = new BigInteger(2);

        private BigInteger k = BigInteger.One;
        private BigInteger l = new BigInteger(3);
        private BigInteger n = new BigInteger(3);
        private BigInteger q = BigInteger.One;
        private BigInteger r = BigInteger.Zero;
        private BigInteger t = BigInteger.One;

        public void CalcPiDigits() {
            BigInteger nn, nr;
            bool first = true;
            while (true) {
                if ((FOUR*q + r - t).CompareTo(n*t) == -1) {
                    Console.Write(n);
                    if (first) {
                        Console.Write(".");
                        first = false;
                    }
                    nr = TEN*(r - (n*t));
                    n = TEN*(THREE*q + r)/t - (TEN*n);
                    q *= TEN;
                    r = nr;
                } else {
                    nr = (TWO*q + r)*l;
                    nn = (q*(SEVEN*k) + TWO + r*l)/(t*l);
                    q *= k;
                    t *= l;
                    l += TWO;
                    k += BigInteger.One;
                    n = nn;
                    r = nr;
                }
            }
        }

        private static void Main(string[] args) {
            new Program().CalcPiDigits();
        }
    }
}
