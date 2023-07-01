using System;
using System.Collections.Generic;

namespace ContinuedFraction {
    class Program {
        static double Calc(Func<int, int[]> f, int n) {
            double temp = 0.0;
            for (int ni = n; ni >= 1; ni--) {
                int[] p = f(ni);
                temp = p[1] / (p[0] + temp);
            }
            return f(0)[0] + temp;
        }

        static void Main(string[] args) {
            List<Func<int, int[]>> fList = new List<Func<int, int[]>>();
            fList.Add(n => new int[] { n > 0 ? 2 : 1, 1 });
            fList.Add(n => new int[] { n > 0 ? n : 2, n > 1 ? (n - 1) : 1 });
            fList.Add(n => new int[] { n > 0 ? 6 : 3, (int) Math.Pow(2 * n - 1, 2) });

            foreach (var f in fList) {
                Console.WriteLine(Calc(f, 200));
            }
        }
    }
}
