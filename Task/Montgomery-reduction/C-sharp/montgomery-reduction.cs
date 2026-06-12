using System;
using System.Numerics;

namespace MontgomeryReduction {
    public static class Helper {
        public static int BitLength(this BigInteger v) {
            if (v < 0) {
                v *= -1;
            }

            int result = 0;
            while (v > 0) {
                v >>= 1;
                result++;
            }

            return result;
        }
    }

    struct Montgomery {
        public static readonly int BASE = 2;

        public BigInteger m;
        public BigInteger rrm;
        public int n;

        public Montgomery(BigInteger m) {
            if (m < 0 || m.IsEven) throw new ArgumentException();

            this.m = m;
            n = m.BitLength();
            rrm = (BigInteger.One << (n * 2)) % m;
        }

        public BigInteger Reduce(BigInteger t) {
            var a = t;

            for (int i = 0; i < n; i++) {
                if (!a.IsEven) a += m;
                a = a >> 1;
            }
            if (a >= m) a -= m;
            return a;
        }
    }

    class Program {
        static void Main(string[] args) {
            var m = BigInteger.Parse("750791094644726559640638407699");
            var x1 = BigInteger.Parse("540019781128412936473322405310");
            var x2 = BigInteger.Parse("515692107665463680305819378593");

            var mont = new Montgomery(m);
            var t1 = x1 * mont.rrm;
            var t2 = x2 * mont.rrm;

            var r1 = mont.Reduce(t1);
            var r2 = mont.Reduce(t2);
            var r = BigInteger.One << mont.n;

            Console.WriteLine("b :  {0}", Montgomery.BASE);
            Console.WriteLine("n :  {0}", mont.n);
            Console.WriteLine("r :  {0}", r);
            Console.WriteLine("m :  {0}", mont.m);
            Console.WriteLine("t1:  {0}", t1);
            Console.WriteLine("t2:  {0}", t2);
            Console.WriteLine("r1:  {0}", r1);
            Console.WriteLine("r2:  {0}", r2);
            Console.WriteLine();
            Console.WriteLine("Original x1       : {0}", x1);
            Console.WriteLine("Recovered from r1 : {0}", mont.Reduce(r1));
            Console.WriteLine("Original x2       : {0}", x2);
            Console.WriteLine("Recovered from r2 : {0}", mont.Reduce(r2));

            Console.WriteLine();
            Console.WriteLine("Montgomery computation of x1 ^ x2 mod m :");
            var prod = mont.Reduce(mont.rrm);
            var @base = mont.Reduce(x1 * mont.rrm);
            var exp = x2;
            while (exp.BitLength() > 0) {
                if (!exp.IsEven) prod = mont.Reduce(prod * @base);
                exp >>= 1;
                @base = mont.Reduce(@base * @base);
            }
            Console.WriteLine(mont.Reduce(prod));
            Console.WriteLine();
            Console.WriteLine("Alternate computation of x1 ^ x2 mod m :");
            Console.WriteLine(BigInteger.ModPow(x1, x2, m));
        }
    }
}
