using System;
using System.Collections.Generic;

namespace RecamanSequence {
    class Program {
        static void Main(string[] args) {
            List<int> a = new List<int>() { 0 };
            HashSet<int> used = new HashSet<int>() { 0 };
            HashSet<int> used1000 = new HashSet<int>() { 0 };
            bool foundDup = false;
            int n = 1;
            while (n <= 15 || !foundDup || used1000.Count < 1001) {
                int next = a[n - 1] - n;
                if (next < 1 || used.Contains(next)) {
                    next += 2 * n;
                }
                bool alreadyUsed = used.Contains(next);
                a.Add(next);
                if (!alreadyUsed) {
                    used.Add(next);
                    if (0 <= next && next <= 1000) {
                        used1000.Add(next);
                    }
                }
                if (n == 14) {
                    Console.WriteLine("The first 15 terms of the Recaman sequence are: [{0}]", string.Join(", ", a));
                }
                if (!foundDup && alreadyUsed) {
                    Console.WriteLine("The first duplicated term is a[{0}] = {1}", n, next);
                    foundDup = true;
                }
                if (used1000.Count == 1001) {
                    Console.WriteLine("Terms up to a[{0}] are needed to generate 0 to 1000", n);
                }
                n++;
            }
        }
    }
}
