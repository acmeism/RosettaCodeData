using System;
using System.Collections.Generic;

namespace ShoelaceFormula {
    using Point = Tuple<double, double>;

    class Program {
        static double ShoelaceArea(List<Point> v) {
            int n = v.Count;
            double a = 0.0;
            for (int i = 0; i < n - 1; i++) {
                a += v[i].Item1 * v[i + 1].Item2 - v[i + 1].Item1 * v[i].Item2;
            }
            return Math.Abs(a + v[n - 1].Item1 * v[0].Item2 - v[0].Item1 * v[n - 1].Item2) / 2.0;
        }

        static void Main(string[] args) {
            List<Point> v = new List<Point>() {
                new Point(3,4),
                new Point(5,11),
                new Point(12,8),
                new Point(9,5),
                new Point(5,6),
            };
            double area = ShoelaceArea(v);
            Console.WriteLine("Given a polygon with vertices [{0}],", string.Join(", ", v));
            Console.WriteLine("its area is {0}.", area);
        }
    }
}
