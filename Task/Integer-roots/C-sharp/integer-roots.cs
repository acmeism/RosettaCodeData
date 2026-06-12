using System;
using System.Numerics;

namespace IntegerRoots {
    class Program {
        static BigInteger IRoot(BigInteger @base, int n) {
            if (@base < 0 || n <= 0) {
                throw new ArgumentException();
            }

            int n1 = n - 1;
            BigInteger n2 = n;
            BigInteger n3 = n1;
            BigInteger c = 1;
            BigInteger d = (n3 + @base) / n2;
            BigInteger e = ((n3 * d) + (@base / BigInteger.Pow(d, n1))) / n2;
            while (c != d && c != e) {
                c = d;
                d = e;
                e = (n3 * e + @base / BigInteger.Pow(e, n1)) / n2;
            }
            if (d < e) {
                return d;
            }
            return e;
        }

        static void Main(string[] args) {
            Console.WriteLine("3rd integer root of 8 = {0}", IRoot(8, 3));
            Console.WriteLine("3rd integer root of 9 = {0}", IRoot(9, 3));

            BigInteger b = BigInteger.Pow(100, 2000) * 2;
            Console.WriteLine("First 2001 digits of the square root of 2: {0}", IRoot(b, 2));
        }
    }
}
