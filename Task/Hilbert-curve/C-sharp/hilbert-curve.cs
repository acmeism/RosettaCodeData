using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Text;

namespace HilbertCurve {
    class Program {
        static void Swap<T>(ref T a, ref T b) {
            var c = a;
            a = b;
            b = c;
        }

        struct Point {
            public int x, y;

            public Point(int x, int y) {
                this.x = x;
                this.y = y;
            }

            //rotate/flip a quadrant appropriately
            public void Rot(int n, bool rx, bool ry) {
                if (!ry) {
                    if (rx) {
                        x = (n - 1) - x;
                        y = (n - 1) - y;
                    }
                    Swap(ref x, ref y);
                }
            }

            public override string ToString() {
                return string.Format("({0}, {1})", x, y);
            }
        }

        static Point FromD(int n, int d) {
            var p = new Point(0, 0);
            int t = d;

            for (int s = 1; s < n; s <<= 1) {
                var rx = (t & 2) != 0;
                var ry = ((t ^ (rx ? 1 : 0)) & 1) != 0;
                p.Rot(s, rx, ry);
                p.x += rx ? s : 0;
                p.y += ry ? s : 0;
                t >>= 2;
            }

            return p;
        }

        static List<Point> GetPointsForCurve(int n) {
            var points = new List<Point>();
            int d = 0;
            while (d < n * n) {
                points.Add(FromD(n, d));
                d += 1;
            }
            return points;
        }

        static List<string> DrawCurve(List<Point> points, int n) {
            var canvas = new char[n, n * 3 - 2];
            for (int i = 0; i < canvas.GetLength(0); i++) {
                for (int j = 0; j < canvas.GetLength(1); j++) {
                    canvas[i, j] = ' ';
                }
            }

            for (int i = 1; i < points.Count; i++) {
                var lastPoint = points[i - 1];
                var curPoint = points[i];
                var deltaX = curPoint.x - lastPoint.x;
                var deltaY = curPoint.y - lastPoint.y;
                if (deltaX == 0) {
                    Debug.Assert(deltaY != 0, "Duplicate point");
                    //vertical line
                    int row = Math.Max(curPoint.y, lastPoint.y);
                    int col = curPoint.x * 3;
                    canvas[row, col] = '|';
                } else {
                    Debug.Assert(deltaY == 0, "Duplicate point");
                    //horizontal line
                    var row = curPoint.y;
                    var col = Math.Min(curPoint.x, lastPoint.x) * 3 + 1;
                    canvas[row, col] = '_';
                    canvas[row, col + 1] = '_';
                }
            }

            var lines = new List<string>();
            for (int i = 0; i < canvas.GetLength(0); i++) {
                var sb = new StringBuilder();
                for (int j = 0; j < canvas.GetLength(1); j++) {
                    sb.Append(canvas[i, j]);
                }
                lines.Add(sb.ToString());
            }
            return lines;
        }

        static void Main() {
            for (int order = 1; order <= 5; order++) {
                var n = 1 << order;
                var points = GetPointsForCurve(n);
                Console.WriteLine("Hilbert curve, order={0}", order);
                var lines = DrawCurve(points, n);
                foreach (var line in lines) {
                    Console.WriteLine(line);
                }
                Console.WriteLine();
            }
        }
    }
}
