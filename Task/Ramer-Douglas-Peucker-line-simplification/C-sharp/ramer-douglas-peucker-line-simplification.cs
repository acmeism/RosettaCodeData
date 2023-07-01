using System;
using System.Collections.Generic;
using System.Linq;

namespace LineSimplification {
    using Point = Tuple<double, double>;

    class Program {
        static double PerpendicularDistance(Point pt, Point lineStart, Point lineEnd) {
            double dx = lineEnd.Item1 - lineStart.Item1;
            double dy = lineEnd.Item2 - lineStart.Item2;

            // Normalize
            double mag = Math.Sqrt(dx * dx + dy * dy);
            if (mag > 0.0) {
                dx /= mag;
                dy /= mag;
            }
            double pvx = pt.Item1 - lineStart.Item1;
            double pvy = pt.Item2 - lineStart.Item2;

            // Get dot product (project pv onto normalized direction)
            double pvdot = dx * pvx + dy * pvy;

            // Scale line direction vector and subtract it from pv
            double ax = pvx - pvdot * dx;
            double ay = pvy - pvdot * dy;

            return Math.Sqrt(ax * ax + ay * ay);
        }

        static void RamerDouglasPeucker(List<Point> pointList, double epsilon, List<Point> output) {
            if (pointList.Count < 2) {
                throw new ArgumentOutOfRangeException("Not enough points to simplify");
            }

            // Find the point with the maximum distance from line between the start and end
            double dmax = 0.0;
            int index = 0;
            int end = pointList.Count - 1;
            for (int i = 1; i < end; ++i) {
                double d = PerpendicularDistance(pointList[i], pointList[0], pointList[end]);
                if (d > dmax) {
                    index = i;
                    dmax = d;
                }
            }

            // If max distance is greater than epsilon, recursively simplify
            if (dmax > epsilon) {
                List<Point> recResults1 = new List<Point>();
                List<Point> recResults2 = new List<Point>();
                List<Point> firstLine = pointList.Take(index + 1).ToList();
                List<Point> lastLine = pointList.Skip(index).ToList();
                RamerDouglasPeucker(firstLine, epsilon, recResults1);
                RamerDouglasPeucker(lastLine, epsilon, recResults2);

                // build the result list
                output.AddRange(recResults1.Take(recResults1.Count - 1));
                output.AddRange(recResults2);
                if (output.Count < 2) throw new Exception("Problem assembling output");
            }
            else {
                // Just return start and end points
                output.Clear();
                output.Add(pointList[0]);
                output.Add(pointList[pointList.Count - 1]);
            }
        }

        static void Main(string[] args) {
            List<Point> pointList = new List<Point>() {
                new Point(0.0,0.0),
                new Point(1.0,0.1),
                new Point(2.0,-0.1),
                new Point(3.0,5.0),
                new Point(4.0,6.0),
                new Point(5.0,7.0),
                new Point(6.0,8.1),
                new Point(7.0,9.0),
                new Point(8.0,9.0),
                new Point(9.0,9.0),
            };
            List<Point> pointListOut = new List<Point>();
            RamerDouglasPeucker(pointList, 1.0, pointListOut);
            Console.WriteLine("Points remaining after simplification:");
            pointListOut.ForEach(p => Console.WriteLine(p));
        }
    }
}
