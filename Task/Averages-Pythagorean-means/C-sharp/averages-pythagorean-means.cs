using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;

namespace PythMean
{
    static class Program
    {
        static void Main(string[] args) {
            var nums = from n in Enumerable.Range(1, 10) select (double)n;

            var a = nums.Average();
            var g = nums.Gmean();
            var h = nums.Hmean();

            Console.WriteLine("Arithmetic mean {0}", a);
            Console.WriteLine("Geometric mean  {0}", g);
            Console.WriteLine("Harmonic mean   {0}", h);

            Debug.Assert(a >= g && g >= h);
        }

        // Geometric mean extension method.
        static double Gmean(this IEnumerable<double> n) {
            return Math.Pow(n.Aggregate((s, i) => s * i), 1.0 / n.Count());
        }

        // Harmonic mean extension method.
        static double Hmean(this IEnumerable<double> n) {
            return n.Count() / n.Sum(i => 1.0 / i);
        }
    }
}
