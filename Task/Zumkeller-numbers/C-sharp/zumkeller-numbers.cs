using System;
using System.Collections.Generic;
using System.Linq;

namespace ZumkellerNumbers {
    class Program {
        static List<int> GetDivisors(int n) {
            List<int> divs = new List<int> {
                1, n
            };
            for (int i = 2; i * i <= n; i++) {
                if (n % i == 0) {
                    int j = n / i;
                    divs.Add(i);
                    if (i != j) {
                        divs.Add(j);
                    }
                }
            }
            return divs;
        }

        static bool IsPartSum(List<int> divs, int sum) {
            if (sum == 0) {
                return true;
            }
            var le = divs.Count;
            if (le == 0) {
                return false;
            }
            var last = divs[le - 1];
            List<int> newDivs = new List<int>();
            for (int i = 0; i < le - 1; i++) {
                newDivs.Add(divs[i]);
            }
            if (last > sum) {
                return IsPartSum(newDivs, sum);
            }
            return IsPartSum(newDivs, sum) || IsPartSum(newDivs, sum - last);
        }

        static bool IsZumkeller(int n) {
            var divs = GetDivisors(n);
            var sum = divs.Sum();
            // if sum is odd can't be split into two partitions with equal sums
            if (sum % 2 == 1) {
                return false;
            }
            // if n is odd use 'abundant odd number' optimization
            if (n % 2 == 1) {
                var abundance = sum - 2 * n;
                return abundance > 0 && abundance % 2 == 0;
            }
            // if n and sum are both even check if there's a partition which totals sum / 2
            return IsPartSum(divs, sum / 2);
        }

        static void Main() {
            Console.WriteLine("The first 220 Zumkeller numbers are:");
            int i = 2;
            for (int count = 0; count < 220; i++) {
                if (IsZumkeller(i)) {
                    Console.Write("{0,3} ", i);
                    count++;
                    if (count % 20 == 0) {
                        Console.WriteLine();
                    }
                }
            }

            Console.WriteLine("\nThe first 40 odd Zumkeller numbers are:");
            i = 3;
            for (int count = 0; count < 40; i += 2) {
                if (IsZumkeller(i)) {
                    Console.Write("{0,5} ", i);
                    count++;
                    if (count % 10 == 0) {
                        Console.WriteLine();
                    }
                }
            }

            Console.WriteLine("\nThe first 40 odd Zumkeller numbers which don't end in 5 are:");
            i = 3;
            for (int count = 0; count < 40; i += 2) {
                if (i % 10 != 5 && IsZumkeller(i)) {
                    Console.Write("{0,7} ", i);
                    count++;
                    if (count % 8 == 0) {
                        Console.WriteLine();
                    }
                }
            }
        }
    }
}
