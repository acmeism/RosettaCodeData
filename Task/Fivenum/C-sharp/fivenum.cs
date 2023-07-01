using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Fivenum {
    public static class Helper {
        public static string AsString<T>(this ICollection<T> c, string format = "{0}") {
            StringBuilder sb = new StringBuilder("[");
            int count = 0;
            foreach (var t in c) {
                if (count++ > 0) {
                    sb.Append(", ");
                }
                sb.AppendFormat(format, t);
            }
            return sb.Append("]").ToString();
        }
    }

    class Program {
        static double Median(double[] x, int start, int endInclusive) {
            int size = endInclusive - start + 1;
            if (size <= 0) throw new ArgumentException("Array slice cannot be empty");
            int m = start + size / 2;
            return (size % 2 == 1) ? x[m] : (x[m - 1] + x[m]) / 2.0;
        }

        static double[] Fivenum(double[] x) {
            foreach (var d in x) {
                if (Double.IsNaN(d)) {
                    throw new ArgumentException("Unable to deal with arrays containing NaN");
                }
            }
            double[] result = new double[5];
            Array.Sort(x);
            result[0] = x.First();
            result[2] = Median(x, 0, x.Length - 1);
            result[4] = x.Last();
            int m = x.Length / 2;
            int lowerEnd = (x.Length % 2 == 1) ? m : m - 1;
            result[1] = Median(x, 0, lowerEnd);
            result[3] = Median(x, m, x.Length - 1);
            return result;
        }

        static void Main(string[] args) {
            double[][] x1 = new double[][]{
                new double[]{ 15.0, 6.0, 42.0, 41.0, 7.0, 36.0, 49.0, 40.0, 39.0, 47.0, 43.0},
                new double[]{ 36.0, 40.0, 7.0, 39.0, 41.0, 15.0},
                new double[]{
                     0.14082834,  0.09748790,  1.73131507,  0.87636009, -1.95059594,  0.73438555,
                    -0.03035726,  1.46675970, -0.74621349, -0.72588772,  0.63905160,  0.61501527,
                    -0.98983780, -1.00447874, -0.62759469,  0.66206163,  1.04312009, -0.10305385,
                     0.75775634,  0.32566578
                },
            };
            foreach(var x in x1) {
                var result = Fivenum(x);
                Console.WriteLine(result.AsString("{0:F8}"));
            }
        }
    }
}
