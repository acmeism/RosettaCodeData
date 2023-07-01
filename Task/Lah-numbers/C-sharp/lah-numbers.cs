using System;
using System.Linq;
using System.Numerics;

namespace LahNumbers {
    class Program {
        static BigInteger Factorial(BigInteger n) {
            if (n == 0) return 1;
            BigInteger res = 1;
            while (n > 0) {
                res *= n--;
            }
            return res;
        }

        static BigInteger Lah(BigInteger n, BigInteger k) {
            if (k == 1) return Factorial(n);
            if (k == n) return 1;
            if (k > n) return 0;
            if (k < 1 || n < 1) return 0;
            return (Factorial(n) * Factorial(n - 1)) / (Factorial(k) * Factorial(k - 1)) / Factorial(n - k);
        }

        static void Main() {
            Console.WriteLine("Unsigned Lah numbers: L(n, k):");
            Console.Write("n/k ");
            foreach (var i in Enumerable.Range(0, 13)) {
                Console.Write("{0,10} ", i);
            }
            Console.WriteLine();
            foreach (var row in Enumerable.Range(0, 13)) {
                Console.Write("{0,-3}", row);
                foreach (var i in Enumerable.Range(0, row + 1)) {
                    var l = Lah(row, i);
                    Console.Write("{0,11}", l);
                }
                Console.WriteLine();
            }
            Console.WriteLine("\nMaximum value from the L(100, *) row:");
            var maxVal = Enumerable.Range(0, 100).Select(a => Lah(100, a)).Max();
            Console.WriteLine(maxVal);
        }
    }
}
