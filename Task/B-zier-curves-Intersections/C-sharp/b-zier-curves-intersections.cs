using System;
using System.Collections.Generic;

public class BezierCurveIntersection
{
    public static void Main(string[] args)
    {
        QuadCurve vertical = new QuadCurve(new QuadSpline(-1.0, 0.0, 1.0), new QuadSpline(0.0, 10.0, 0.0));
        // QuadCurve vertical represents the Bezier curve having control points (-1, 0), (0, 10) and (1, 0)
        QuadCurve horizontal = new QuadCurve(new QuadSpline(2.0, -8.0, 2.0), new QuadSpline(1.0, 2.0, 3.0));
        // QuadCurve horizontal represents the Bezier curve having control points (2, 1), (-8, 2) and (2, 3) 		

        Console.WriteLine("The points of intersection are:");
        List<Point> intersects = FindIntersects(vertical, horizontal);
        foreach (Point intersect in intersects)
        {
            Console.WriteLine($"( {intersect.X,9:0.000000}, {intersect.Y,9:0.000000} )");
        }
    }

    private static List<Point> FindIntersects(QuadCurve p, QuadCurve q)
    {
        List<Point> result = new List<Point>();
        Stack<QuadCurve> stack = new Stack<QuadCurve>();
        stack.Push(p);
        stack.Push(q);

        while (stack.Count > 0)
        {
            QuadCurve pp = stack.Pop();
            QuadCurve qq = stack.Pop();
            List<object> objects = TestIntersection(pp, qq);
            bool accepted = (bool)objects[0];
            bool excluded = (bool)objects[1];
            Point intersect = (Point)objects[2];

            if (accepted)
            {
                if (!SeemsToBeDuplicate(result, intersect))
                {
                    result.Add(intersect);
                }
            }
            else if (!excluded)
            {
                QuadCurve p0 = new QuadCurve();
                QuadCurve q0 = new QuadCurve();
                QuadCurve p1 = new QuadCurve();
                QuadCurve q1 = new QuadCurve();
                SubdivideQuadCurve(pp, 0.5, p0, p1);
                SubdivideQuadCurve(qq, 0.5, q0, q1);
                stack.Push(p0);
                stack.Push(q0);
                stack.Push(p0);
                stack.Push(q1);
                stack.Push(p1);
                stack.Push(q0);
                stack.Push(p1);
                stack.Push(q1);
            }
        }
        return result;
    }

    private static bool SeemsToBeDuplicate(List<Point> intersects, Point point)
    {
        foreach (Point intersect in intersects)
        {
            if (Math.Abs(intersect.X - point.X) < Spacing && Math.Abs(intersect.Y - point.Y) < Spacing)
            {
                return true;
            }
        }
        return false;
    }

    private static List<object> TestIntersection(QuadCurve p, QuadCurve q)
    {
        double pxMin = Math.Min(Math.Min(p.X.C0, p.X.C1), p.X.C2);
        double pyMin = Math.Min(Math.Min(p.Y.C0, p.Y.C1), p.Y.C2);
        double pxMax = Math.Max(Math.Max(p.X.C0, p.X.C1), p.X.C2);
        double pyMax = Math.Max(Math.Max(p.Y.C0, p.Y.C1), p.Y.C2);

        double qxMin = Math.Min(Math.Min(q.X.C0, q.X.C1), q.X.C2);
        double qyMin = Math.Min(Math.Min(q.Y.C0, q.Y.C1), q.Y.C2);
        double qxMax = Math.Max(Math.Max(q.X.C0, q.X.C1), q.X.C2);
        double qyMax = Math.Max(Math.Max(q.Y.C0, q.Y.C1), q.Y.C2);

        bool accepted = false;
        bool excluded = true;
        Point intersect = new Point(0.0, 0.0);

        if (RectanglesOverlap(pxMin, pyMin, pxMax, pyMax, qxMin, qyMin, qxMax, qyMax))
        {
            excluded = false;
            double xMin = Math.Max(pxMin, qxMin);
            double xMax = Math.Min(pxMax, pxMax);
            if (xMax - xMin <= Tolerance)
            {
                double yMin = Math.Max(pyMin, qyMin);
                double yMax = Math.Min(pyMax, qyMax);
                if (yMax - yMin <= Tolerance)
                {
                    accepted = true;
                    intersect = new Point(0.5 * (xMin + xMax), 0.5 * (yMin + yMax));
                }
            }
        }
        return new List<object> { accepted, excluded, intersect };
    }

    private static bool RectanglesOverlap(double xa0, double ya0, double xa1, double ya1,
                                          double xb0, double yb0, double xb1, double yb1)
    {
        return xb0 <= xa1 && xa0 <= xb1 && yb0 <= ya1 && ya0 <= yb1;
    }

    private static void SubdivideQuadCurve(QuadCurve q, double t, QuadCurve u, QuadCurve v)
    {
        SubdivideQuadSpline(q.X, t, u.X, v.X);
        SubdivideQuadSpline(q.Y, t, u.Y, v.Y);
    }

    // de Casteljau's algorithm
    private static void SubdivideQuadSpline(QuadSpline q, double t, QuadSpline u, QuadSpline v)
    {
        double s = 1.0 - t;
        u.C0 = q.C0;
        v.C2 = q.C2;
        u.C1 = s * q.C0 + t * q.C1;
        v.C1 = s * q.C1 + t * q.C2;
        u.C2 = s * u.C1 + t * v.C1;
        v.C0 = u.C2;
    }

    public struct Point
    {
        public double X { get; }
        public double Y { get; }

        public Point(double x, double y)
        {
            X = x;
            Y = y;
        }
    }

    public class QuadSpline
    {
        public double C0 { get; set; }
        public double C1 { get; set; }
        public double C2 { get; set; }

        public QuadSpline(double c0, double c1, double c2)
        {
            C0 = c0;
            C1 = c1;
            C2 = c2;
        }

        public QuadSpline() : this(0.0, 0.0, 0.0) { }
    }

    public class QuadCurve
    {
        public QuadSpline X { get; set; }
        public QuadSpline Y { get; set; }

        public QuadCurve(QuadSpline x, QuadSpline y)
        {
            X = x;
            Y = y;
        }

        public QuadCurve() : this(new QuadSpline(), new QuadSpline()) { }
    }

    private const double Tolerance = 0.000_000_1;
    private const double Spacing = 10 * Tolerance;
}
