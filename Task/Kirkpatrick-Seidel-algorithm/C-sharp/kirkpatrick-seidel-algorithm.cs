using System;
using System.Collections.Generic;
using System.Linq;
using System.Diagnostics;

public class ConvexHullAlgorithm
{
    public class Point : IComparable<Point>
    {
        public double X { get; set; }
        public double Y { get; set; }

        public Point() : this(0, 0) { }

        public Point(double x, double y)
        {
            X = x;
            Y = y;
        }

        public int CompareTo(Point other)
        {
            if (X == other.X)
            {
                return Y.CompareTo(other.Y);
            }
            return X.CompareTo(other.X);
        }

        public override bool Equals(object obj)
        {
            if (obj == null || GetType() != obj.GetType())
            {
                return false;
            }
            Point other = (Point)obj;
            return X == other.X && Y == other.Y;
        }

        public override int GetHashCode()
        {
            unchecked
            {
                int hash = 17;
                hash = hash * 23 + X.GetHashCode();
                hash = hash * 23 + Y.GetHashCode();
                return hash;
            }
        }

        public static bool operator <(Point p1, Point p2)
        {
            if (p1.X == p2.X)
            {
                return p1.Y < p2.Y;
            }
            return p1.X < p2.X;
        }

        public static bool operator >(Point p1, Point p2)
        {
            if (p1.X == p2.X)
            {
                return p1.Y > p2.Y;
            }
            return p1.X > p2.X;
        }

        public static bool operator ==(Point p1, Point p2)
        {
            if (ReferenceEquals(p1, p2)) return true;
            if (ReferenceEquals(p1, null) || ReferenceEquals(p2, null)) return false;
            return p1.X == p2.X && p1.Y == p2.Y;
        }

        public static bool operator !=(Point p1, Point p2)
        {
            return !(p1 == p2);
        }
    }

    private static Random rand = new Random();

    private static List<Point> Flipped(IEnumerable<Point> points)
    {
        List<Point> result = new List<Point>();
        foreach (var point in points)
        {
            result.Add(new Point(-point.X, -point.Y));
        }
        return result;
    }

    private static T QuickSelect<T>(List<T> ls, int index, int lo = 0, int hi = -1) where T : IComparable<T>
    {
        if (hi == -1)
        {
            hi = ls.Count - 1;
        }

        if (lo == hi)
        {
            return ls[lo];
        }

        int pivotIndex = lo + rand.Next(hi - lo + 1);
        T pivotValue = ls[pivotIndex];
        Swap(ls, lo, pivotIndex);

        int cur = lo;
        for (int run = lo + 1; run <= hi; run++)
        {
            if (ls[run].CompareTo(pivotValue) < 0)
            {
                cur++;
                Swap(ls, cur, run);
            }
        }

        Swap(ls, cur, lo);

        if (index < cur)
        {
            return QuickSelect(ls, index, lo, cur - 1);
        }
        else if (index > cur)
        {
            return QuickSelect(ls, index, cur + 1, hi);
        }
        else
        {
            return ls[cur];
        }
    }

    private static void Swap<T>(List<T> list, int i, int j)
    {
        T temp = list[i];
        list[i] = list[j];
        list[j] = temp;
    }

    private static Tuple<Point, Point> Bridge(HashSet<Point> points, double verticalLine)
    {
        HashSet<Point> candidates = new HashSet<Point>();

        if (points.Count == 2)
        {
            return Tuple.Create(points.Min(), points.Max());
        }

        List<Tuple<Point, Point>> pairs = new List<Tuple<Point, Point>>();
        List<Point> modifyList = points.ToList();

        for (int i = 0; i < modifyList.Count / 2 * 2; i += 2)
        {
            Point p1 = modifyList[i];
            Point p2 = modifyList[i + 1];
            if (p1 < p2)
            {
                pairs.Add(Tuple.Create(p1, p2));
            }
            else
            {
                pairs.Add(Tuple.Create(p2, p1));
            }
        }

        if (modifyList.Count % 2 == 1)
        {
            candidates.Add(modifyList.Last());
        }

        List<double> slopes = new List<double>();
        List<Tuple<Point, Point>> validPairs = new List<Tuple<Point, Point>>();

        foreach (var pair in pairs)
        {
            if (pair.Item1.X == pair.Item2.X)
            {
                candidates.Add(pair.Item1.Y > pair.Item2.Y ? pair.Item1 : pair.Item2);
            }
            else
            {
                slopes.Add((pair.Item1.Y - pair.Item2.Y) / (pair.Item1.X - pair.Item2.X));
                validPairs.Add(pair);
            }
        }

        if (slopes.Count == 0)
        {
            if (candidates.Count >= 2)
            {
                return Tuple.Create(candidates.Min(), candidates.Max());
            }
             // If we don't have enough candidates, return the first pair
             var pointList = points.ToList();
             return Tuple.Create(pointList[0], pointList[1]);
        }


        int medianIndex = slopes.Count / 2 - (slopes.Count % 2 == 0 ? 1 : 0);
        double medianSlope = QuickSelect(slopes, medianIndex);

        HashSet<Tuple<Point, Point>> small = new HashSet<Tuple<Point, Point>>();
        HashSet<Tuple<Point, Point>> equal = new HashSet<Tuple<Point, Point>>();
        HashSet<Tuple<Point, Point>> large = new HashSet<Tuple<Point, Point>>();

        for (int i = 0; i < slopes.Count; i++)
        {
            if (slopes[i] < medianSlope)
            {
                small.Add(validPairs[i]);
            }
            else if (slopes[i] == medianSlope)
            {
                equal.Add(validPairs[i]);
            }
            else
            {
                large.Add(validPairs[i]);
            }
        }

        double maxSlope = double.NegativeInfinity;
        foreach (var point in points)
        {
            maxSlope = Math.Max(maxSlope, point.Y - medianSlope * point.X);
        }

        List<Point> maxSet = new List<Point>();
        foreach (var point in points)
        {
            if (point.Y - medianSlope * point.X == maxSlope)
            {
                maxSet.Add(point);
            }
        }

        Point left = maxSet.Min();
        Point right = maxSet.Max();

        if (left.X <= verticalLine && right.X > verticalLine)
        {
            return Tuple.Create(left, right);
        }

        if (right.X <= verticalLine)
        {
            foreach (var pair in large)
            {
                candidates.Add(pair.Item2);
            }
            foreach (var pair in equal)
            {
                candidates.Add(pair.Item2);
            }
            foreach (var pair in small)
            {
                candidates.Add(pair.Item1);
                candidates.Add(pair.Item2);
            }
        }

        if (left.X > verticalLine)
        {
            foreach (var pair in small)
            {
                candidates.Add(pair.Item1);
            }
            foreach (var pair in equal)
            {
                candidates.Add(pair.Item1);
            }
            foreach (var pair in large)
            {
                candidates.Add(pair.Item1);
                candidates.Add(pair.Item2);
            }
        }

        return Bridge(candidates, verticalLine);
    }

    private static List<Point> Connect(Point lower, Point upper, HashSet<Point> points)
    {
        if (lower == upper)
        {
            return new List<Point> { lower };
        }

        List<Point> pointsVec = points.ToList();
        pointsVec.Sort(); // Sort required for quickselect index logic

        int midIndex = (pointsVec.Count - 1) / 2;

        Point maxLeft = QuickSelect(pointsVec, midIndex);
        Point minRight = QuickSelect(pointsVec, midIndex + 1);

        var bridgePoints = Bridge(points, (maxLeft.X + minRight.X) / 2);
        Point left = bridgePoints.Item1;
        Point right = bridgePoints.Item2;

        HashSet<Point> pointsLeft = new HashSet<Point> { left };
        HashSet<Point> pointsRight = new HashSet<Point> { right };

        foreach (var point in points)
        {
            if (point.X < left.X)
            {
                pointsLeft.Add(point);
            }
            else if (point.X > right.X)
            {
                pointsRight.Add(point);
            }
        }

        List<Point> leftResult = Connect(lower, left, pointsLeft);
        List<Point> rightResult = Connect(right, upper, pointsRight);

        leftResult.AddRange(rightResult);
        return leftResult;
    }

    private static List<Point> UpperHull(HashSet<Point> points)
    {
        Point lower = points.Min();

        // Find the lowest point with the same x-coordinate as the minimum
        foreach (var point in points)
        {
            if (point.X == lower.X && point.Y > lower.Y)
            {
                lower = point;
            }
        }

        Point upper = points.Max();

        HashSet<Point> filteredPoints = new HashSet<Point> { lower, upper };
        foreach (var p in points)
        {
            if (lower.X < p.X && p.X < upper.X)
            {
                filteredPoints.Add(p);
            }
        }

        return Connect(lower, upper, filteredPoints);
    }

    public static List<Point> ConvexHull(HashSet<Point> points)
    {
        List<Point> upper = UpperHull(points);

        HashSet<Point> flippedPoints = new HashSet<Point>();
        foreach (var p in points)
        {
            flippedPoints.Add(new Point(-p.X, -p.Y));
        }

        List<Point> flippedUpper = UpperHull(flippedPoints);
        List<Point> lower = Flipped(flippedUpper);

        // Remove duplicate points at the start/end
        if (upper.Count > 0 && lower.Count > 0)
        {
            if (upper.Last().Equals(lower.First()))
            {
                upper.RemoveAt(upper.Count - 1);
            }

            if (upper.First().Equals(lower.Last()))
            {
                lower.RemoveAt(lower.Count - 1);
            }
        }


        List<Point> result = upper;
        result.AddRange(lower);

        return result;
    }

    // Test case for a simplex
    public static void Main(string[] args)
    {
        // Create points for a 2D projection of a 3D simplex
        HashSet<Point> points = new HashSet<Point>
        {
            new Point(0.0, 0.0),   // projection of [0.0, 0.0, 0.0]
            new Point(1.0, 0.0),   // projection of [1.0, 0.0, 0.0]
            new Point(0.0, 1.0),   // projection of [0.0, 1.0, 0.0]
            new Point(0.5, 0.5)    // projection of [0.0, 0.0, 1.0] (projected to 2D)
        };

        Console.WriteLine("Input points:");
        foreach (var p in points)
        {
            Console.WriteLine($"({p.X}, {p.Y})");
        }

        List<Point> hull = ConvexHull(points);

        Console.WriteLine("\nConvex hull points:");
        foreach (var p in hull)
        {
            Console.WriteLine($"({p.X}, {p.Y})");
        }
    }
}
