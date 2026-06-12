using System;
using System.Collections.Generic;
using System.Linq;

public class Program
{
    public static void Main()
    {
        Circle circle = ((3, -5), 3);
        Line[] lines = {
            ((-10, 11), (10, -9)),
            ((-10, 11), (-11, 12), true),
            ((3, -2), (7, -2))
        };
        Print(circle, lines);

        circle = ((0, 0), 4);
        lines = new Line[] {
            ((0, -3), (0, 6)),
            ((0, -3), (0, 6), true)
        };
        Print(circle, lines);

        circle = ((4, 2), 5);
        lines = new Line[] {
            ((6, 3), (10, 7)),
            ((7, 4), (11, 8), true)
        };
        Print(circle, lines);
    }

    static void Print(Circle circle, Line[] lines)
    {
        Console.WriteLine($"Circle: {circle}");
        foreach (var line in lines) {
            Console.WriteLine($"\t{(line.IsSegment ? "Segment:" : "Line:")} {line}");
            var points = Intersection(circle, line).ToList();
            Console.WriteLine(points.Count == 0 ? "\t\tdo not intersect" : "\t\tintersect at " + string.Join(" and ", points));
        }
        Console.WriteLine();
    }

    static IEnumerable<Point> Intersection(Circle circle, Line line)
    {
        var intersection = LineIntersection(circle, line);
        return line.IsSegment
            ? intersection.Where(p => p.CompareTo(line.P1) >= 0 && p.CompareTo(line.P2) <= 0)
            : intersection;

        static IEnumerable<Point> LineIntersection(Circle circle, Line line)
        {
            double x, y, A, B, C, D;
            var (m, c) = (line.Slope, line.YIntercept);
            var (p, q, r) = (circle.X, circle.Y, circle.Radius);

            if (line.IsVertical) {
                x = line.P1.X;
                B = -2 * q;
                C = p * p + q * q - r * r + x * x - 2 * p * x;
                D = B * B - 4 * C;
                if (D == 0) yield return (x, -q);
                else if (D > 0) {
                    D = Math.Sqrt(D);
                    yield return (x, (-B - D) / 2);
                    yield return (x, (-B + D) / 2);
                }
            } else {
                A = m * m + 1;
                B = 2 * (m * c - m * q - p);
                C = p * p + q * q - r * r + c * c - 2 * c * q;
                D = B * B - 4 * A * C;
                if (D == 0) {
                    x = -B / (2 * A);
                    y = m * x + c;
                    yield return (x, y);
                } else if (D > 0) {
                    D = Math.Sqrt(D);
                    x = (-B - D) / (2 * A);
                    y = m * x + c;
                    yield return (x, y);
                    x = (-B + D) / (2 * A);
                    y = m * x + c;
                    yield return (x, y);
                }
            }
        }

    }

    readonly struct Point : IComparable<Point>
    {
        public Point(double x, double y) => (X, Y) = (x, y);

        public static implicit operator Point((double x, double y) p) => new Point(p.x, p.y);

        public double X { get; }
        public double Y { get; }

        public int CompareTo(Point other)
        {
            int c = X.CompareTo(other.X);
            if (c != 0) return c;
            return Y.CompareTo(other.Y);
        }

        public override string ToString() => $"({X}, {Y})";
    }

    readonly struct Line
    {
        public Line(Point p1, Point p2, bool isSegment = false)
        {
            (P1, P2) = p2.CompareTo(p1) < 0 ? (p2, p1) : (p1, p2);
            IsSegment = isSegment;
            if (p1.X == p2.X) (Slope, YIntercept) = (double.PositiveInfinity, double.NaN);
            else {
                Slope = (P2.Y - P1.Y) / (P2.X - P1.X);
                YIntercept = P2.Y - Slope * P2.X;
            }
        }

        public static implicit operator Line((Point p1, Point p2) l) => new Line(l.p1, l.p2);
        public static implicit operator Line((Point p1, Point p2, bool isSegment) l) => new Line(l.p1, l.p2, l.isSegment);

        public Point P1 { get; }
        public Point P2 { get; }
        public double Slope { get; }
        public double YIntercept { get; }
        public bool IsSegment { get; }
        public bool IsVertical => P1.X == P2.X;

        public override string ToString() => $"[{P1}, {P2}]";
    }

    readonly struct Circle
    {
        public Circle(Point center, double radius) => (Center, Radius) = (center, radius);

        public static implicit operator Circle((Point center, double radius) c) => new Circle(c.center, c.radius);

        public Point Center { get; }
        public double Radius { get; }
        public double X => Center.X;
        public double Y => Center.Y;

        public override string ToString() => $"{{ C:{Center}, R:{Radius} }}";
    }
}
