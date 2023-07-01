using System;
using System.Collections.Generic;

namespace ConvexHull {
    class Point : IComparable<Point> {
        private int x, y;

        public Point(int x, int y) {
            this.x = x;
            this.y = y;
        }

        public int X { get => x; set => x = value; }
        public int Y { get => y; set => y = value; }

        public int CompareTo(Point other) {
            return x.CompareTo(other.x);
        }

        public override string ToString() {
            return string.Format("({0}, {1})", x, y);
        }
    }

    class Program {
        private static List<Point> ConvexHull(List<Point> p) {
            if (p.Count == 0) return new List<Point>();
            p.Sort();
            List<Point> h = new List<Point>();

            // lower hull
            foreach (var pt in p) {
                while (h.Count >= 2 && !Ccw(h[h.Count - 2], h[h.Count - 1], pt)) {
                    h.RemoveAt(h.Count - 1);
                }
                h.Add(pt);
            }

            // upper hull
            int t = h.Count + 1;
            for (int i = p.Count - 1; i >= 0; i--) {
                Point pt = p[i];
                while (h.Count >= t && !Ccw(h[h.Count - 2], h[h.Count - 1], pt)) {
                    h.RemoveAt(h.Count - 1);
                }
                h.Add(pt);
            }

            h.RemoveAt(h.Count - 1);
            return h;
        }

        private static bool Ccw(Point a, Point b, Point c) {
            return ((b.X - a.X) * (c.Y - a.Y)) > ((b.Y - a.Y) * (c.X - a.X));
        }

        static void Main(string[] args) {
            List<Point> points = new List<Point>() {
                new Point(16, 3),
                new Point(12, 17),
                new Point(0, 6),
                new Point(-4, -6),
                new Point(16, 6),

                new Point(16, -7),
                new Point(16, -3),
                new Point(17, -4),
                new Point(5, 19),
                new Point(19, -8),

                new Point(3, 16),
                new Point(12, 13),
                new Point(3, -4),
                new Point(17, 5),
                new Point(-3, 15),

                new Point(-3, -9),
                new Point(0, 11),
                new Point(-9, -3),
                new Point(-4, -2),
                new Point(12, 10)
            };

            List<Point> hull = ConvexHull(points);
            Console.Write("Convex Hull: [");
            for (int i = 0; i < hull.Count; i++) {
                if (i > 0) {
                    Console.Write(", ");
                }
                Point pt = hull[i];
                Console.Write(pt);
            }
            Console.WriteLine("]");
        }
    }
}
