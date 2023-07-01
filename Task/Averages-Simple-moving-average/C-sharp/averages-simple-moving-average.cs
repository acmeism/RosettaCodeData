using System;
using System.Collections.Generic;
using System.Linq;

namespace SMA {
    class Program {
        static void Main(string[] args) {
            var nums = Enumerable.Range(1, 5).Select(n => (double)n);
            nums = nums.Concat(nums.Reverse());

            var sma3 = SMA(3);
            var sma5 = SMA(5);

            foreach (var n in nums) {
                Console.WriteLine("{0}    (sma3) {1,-16} (sma5) {2,-16}", n, sma3(n), sma5(n));
            }
        }

        static Func<double, double> SMA(int p) {
            Queue<double> s = new Queue<double>(p);
            return (x) => {
                if (s.Count >= p) {
                    s.Dequeue();
                }
                s.Enqueue(x);
                return s.Average();
            };
        }
    }
}
