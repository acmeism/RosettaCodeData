using System;
using System.Collections.Generic;

namespace TriangleOverlap {
    class Triangle {
        public Tuple<double, double> P1 { get; set; }
        public Tuple<double, double> P2 { get; set; }
        public Tuple<double, double> P3 { get; set; }

        public Triangle(Tuple<double, double> p1, Tuple<double, double> p2, Tuple<double, double> p3) {
            P1 = p1;
            P2 = p2;
            P3 = p3;
        }

        public double Det2D() {
            return P1.Item1 * (P2.Item2 - P3.Item2)
                 + P2.Item1 * (P3.Item2 - P1.Item2)
                 + P3.Item1 * (P3.Item1 - P2.Item2);
        }

        public void CheckTriWinding(bool allowReversed) {
            var detTri = Det2D();
            if (detTri < 0.0) {
                if (allowReversed) {
                    var a = P3;
                    P3 = P2;
                    P2 = a;
                } else {
                    throw new Exception("Triangle has wrong winding direction");
                }
            }
        }

        public bool BoundaryCollideChk(double eps) {
            return Det2D() < eps;
        }

        public bool BoundaryDoesntCollideChk(double eps) {
            return Det2D() <= eps;
        }

        public override string ToString() {
            return string.Format("Triangle: {0}, {1}, {2}", P1, P2, P3);
        }
    }

    class Program {
        static bool BoundaryCollideChk(Triangle t, double eps) {
            return t.BoundaryCollideChk(eps);
        }

        static bool BoundaryDoesntCollideChk(Triangle t, double eps) {
            return t.BoundaryDoesntCollideChk(eps);
        }

        static bool TriTri2D(Triangle t1, Triangle t2, double eps = 0.0, bool allowReversed = false, bool onBoundary = true) {
            // Triangles must be expressed anti-clockwise
            t1.CheckTriWinding(allowReversed);
            t2.CheckTriWinding(allowReversed);
            // 'onBoundary' determines whether points on boundary are considered as colliding or not
            var chkEdge = onBoundary
                ? (Func<Triangle, double, bool>)BoundaryCollideChk
                : BoundaryDoesntCollideChk;
            List<Tuple<double, double>> lp1 = new List<Tuple<double, double>>() { t1.P1, t1.P2, t1.P3 };
            List<Tuple<double, double>> lp2 = new List<Tuple<double, double>>() { t2.P1, t2.P2, t2.P3 };

            // for each edge E of t1
            for (int i = 0; i < 3; i++) {
                var j = (i + 1) % 3;
                // Check all points of t2 lay on the external side of edge E.
                // If they do, the triangles do not overlap.
                if (chkEdge(new Triangle(lp1[i], lp1[j], lp2[0]), eps) &&
                    chkEdge(new Triangle(lp1[i], lp1[j], lp2[1]), eps) &&
                    chkEdge(new Triangle(lp1[i], lp1[j], lp2[2]), eps)) {
                    return false;
                }
            }

            // for each edge E of t2
            for (int i = 0; i < 3; i++) {
                var j = (i + 1) % 3;
                // Check all points of t1 lay on the external side of edge E.
                // If they do, the triangles do not overlap.
                if (chkEdge(new Triangle(lp2[i], lp2[j], lp1[0]), eps) &&
                    chkEdge(new Triangle(lp2[i], lp2[j], lp1[1]), eps) &&
                    chkEdge(new Triangle(lp2[i], lp2[j], lp1[2]), eps)) {
                    return false;
                }
            }

            // The triangles overlap
            return true;
        }

        static void Overlap(Triangle t1, Triangle t2, double eps = 0.0, bool allowReversed = false, bool onBoundary = true) {
            if (TriTri2D(t1, t2, eps, allowReversed, onBoundary)) {
                Console.WriteLine("overlap");
            } else {
                Console.WriteLine("do not overlap");
            }
        }

        static void Main(string[] args) {
            var t1 = new Triangle(new Tuple<double, double>(0.0, 0.0), new Tuple<double, double>(5.0, 0.0), new Tuple<double, double>(0.0, 5.0));
            var t2 = new Triangle(new Tuple<double, double>(0.0, 0.0), new Tuple<double, double>(5.0, 0.0), new Tuple<double, double>(0.0, 6.0));
            Console.WriteLine("{0} and\n{1}", t1, t2);
            Overlap(t1, t2);
            Console.WriteLine();

            // need to allow reversed for this pair to avoid exception
            t1 = new Triangle(new Tuple<double, double>(0.0, 0.0), new Tuple<double, double>(0.0, 5.0), new Tuple<double, double>(5.0, 0.0));
            t2 = t1;
            Console.WriteLine("{0} and\n{1}", t1, t2);
            Overlap(t1, t2, 0.0, true);
            Console.WriteLine();

            t1 = new Triangle(new Tuple<double, double>(0.0, 0.0), new Tuple<double, double>(5.0, 0.0), new Tuple<double, double>(0.0, 5.0));
            t2 = new Triangle(new Tuple<double, double>(-10.0, 0.0), new Tuple<double, double>(-5.0, 0.0), new Tuple<double, double>(-1.0, 6.0));
            Console.WriteLine("{0} and\n{1}", t1, t2);
            Overlap(t1, t2);
            Console.WriteLine();

            t1.P3 = new Tuple<double, double>(2.5, 5.0);
            t2 = new Triangle(new Tuple<double, double>(0.0, 4.0), new Tuple<double, double>(2.5, -1.0), new Tuple<double, double>(5.0, 4.0));
            Console.WriteLine("{0} and\n{1}", t1, t2);
            Overlap(t1, t2);
            Console.WriteLine();

            t1 = new Triangle(new Tuple<double, double>(0.0, 0.0), new Tuple<double, double>(1.0, 1.0), new Tuple<double, double>(0.0, 2.0));
            t2 = new Triangle(new Tuple<double, double>(2.0, 1.0), new Tuple<double, double>(3.0, 0.0), new Tuple<double, double>(3.0, 2.0));
            Console.WriteLine("{0} and\n{1}", t1, t2);
            Overlap(t1, t2);
            Console.WriteLine();

            t2 = new Triangle(new Tuple<double, double>(2.0, 1.0), new Tuple<double, double>(3.0, -2.0), new Tuple<double, double>(3.0, 4.0));
            Console.WriteLine("{0} and\n{1}", t1, t2);
            Overlap(t1, t2);
            Console.WriteLine();

            t1 = new Triangle(new Tuple<double, double>(0.0, 0.0), new Tuple<double, double>(1.0, 0.0), new Tuple<double, double>(0.0, 1.0));
            t2 = new Triangle(new Tuple<double, double>(1.0, 0.0), new Tuple<double, double>(2.0, 0.0), new Tuple<double, double>(1.0, 1.1));
            Console.WriteLine("{0} and\n{1}", t1, t2);
            Console.WriteLine("which have only a single corner in contact, if boundary points collide");
            Overlap(t1, t2);
            Console.WriteLine();

            Console.WriteLine("{0} and\n{1}", t1, t2);
            Console.WriteLine("which have only a single corner in contact, if boundary points do not collide");
            Overlap(t1, t2, 0.0, false, false);
        }
    }
}
