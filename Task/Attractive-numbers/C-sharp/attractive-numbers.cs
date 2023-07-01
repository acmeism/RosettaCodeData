using System;

namespace AttractiveNumbers {
    class Program {
        const int MAX = 120;

        static bool IsPrime(int n) {
            if (n < 2) return false;
            if (n % 2 == 0) return n == 2;
            if (n % 3 == 0) return n == 3;
            int d = 5;
            while (d * d <= n) {
                if (n % d == 0) return false;
                d += 2;
                if (n % d == 0) return false;
                d += 4;
            }
            return true;
        }

        static int PrimeFactorCount(int n) {
            if (n == 1) return 0;
            if (IsPrime(n)) return 1;
            int count = 0;
            int f = 2;
            while (true) {
                if (n % f == 0) {
                    count++;
                    n /= f;
                    if (n == 1) return count;
                    if (IsPrime(n)) f = n;
                } else if (f >= 3) {
                    f += 2;
                } else {
                    f = 3;
                }
            }
        }

        static void Main(string[] args) {
            Console.WriteLine("The attractive numbers up to and including {0} are:", MAX);
            int i = 1;
            int count = 0;
            while (i <= MAX) {
                int n = PrimeFactorCount(i);
                if (IsPrime(n)) {
                    Console.Write("{0,4}", i);
                    if (++count % 20 == 0) Console.WriteLine();
                }
                ++i;
            }
            Console.WriteLine();
        }
    }
}
