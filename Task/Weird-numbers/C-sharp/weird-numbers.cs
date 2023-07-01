using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WeirdNumbers {
    class Program {
        static List<int> Divisors(int n) {
            List<int> divs = new List<int> { 1 };
            List<int> divs2 = new List<int>();

            for (int i = 2; i * i <= n; i++) {
                if (n % i == 0) {
                    int j = n / i;
                    divs.Add(i);
                    if (i != j) {
                        divs2.Add(j);
                    }
                }
            }

            divs.Reverse();
            divs2.AddRange(divs);
            return divs2;
        }

        static bool Abundant(int n, List<int> divs) {
            return divs.Sum() > n;
        }

        static bool Semiperfect(int n, List<int> divs) {
            if (divs.Count > 0) {
                var h = divs[0];
                var t = divs.Skip(1).ToList();
                if (n < h) {
                    return Semiperfect(n, t);
                } else {
                    return n == h
                        || Semiperfect(n - h, t)
                        || Semiperfect(n, t);
                }
            } else {
                return false;
            }
        }

        static List<bool> Sieve(int limit) {
            // false denotes abundant and not semi-perfect.
            // Only interested in even numbers >= 2
            bool[] w = new bool[limit];
            for (int i = 2; i < limit; i += 2) {
                if (w[i]) continue;
                var divs = Divisors(i);
                if (!Abundant(i, divs)) {
                    w[i] = true;
                } else if (Semiperfect(i, divs)) {
                    for (int j = i; j < limit; j += i) {
                        w[j] = true;
                    }
                }
            }
            return w.ToList();
        }

        static void Main() {
            var w = Sieve(17_000);
            int count = 0;
            int max = 25;
            Console.WriteLine("The first 25 weird numbers:");
            for (int n = 2; count < max; n += 2) {
                if (!w[n]) {
                    Console.Write("{0} ", n);
                    count++;
                }
            }
            Console.WriteLine();
        }
    }
}
