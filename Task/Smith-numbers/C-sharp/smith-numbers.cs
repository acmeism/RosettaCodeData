using System;
using System.Collections.Generic;

namespace SmithNumbers {
    class Program {
        static int SumDigits(int n) {
            int sum = 0;
            while (n > 0) {
                n = Math.DivRem(n, 10, out int rem);
                sum += rem;
            }
            return sum;
        }

        static List<int> PrimeFactors(int n) {
            List<int> result = new List<int>();

            for (int i = 2; n % i == 0; n /= i) {
                result.Add(i);
            }

            for (int i = 3; i * i < n; i += 2) {
                while (n % i == 0) {
                    result.Add(i);
                    n /= i;
                }
            }

            if (n != 1) {
                result.Add(n);
            }

            return result;
        }

        static void Main(string[] args) {
            const int SIZE = 8;
            int count = 0;
            for (int n = 1; n < 10_000; n++) {
                var factors = PrimeFactors(n);
                if (factors.Count > 1) {
                    int sum = SumDigits(n);
                    foreach (var f in factors) {
                        sum -= SumDigits(f);
                    }
                    if (sum == 0) {
                        Console.Write("{0,5}", n);
                        if (count == SIZE - 1) {
                            Console.WriteLine();
                        }
                        count = (count + 1) % SIZE;
                    }
                }
            }
        }
    }
}
