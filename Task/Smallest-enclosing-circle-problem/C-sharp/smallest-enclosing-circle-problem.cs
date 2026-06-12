using System;
using System.Collections.Generic;
using System.Linq;

public static class SmallestEnclosingCircle
{
    public static void Main(string[] args)
    {
        var tests = new List<List<Point>>
        {
            new List<Point> { new Point(0.0, 0.0), new Point(0.0, 1.0), new Point(1.0, 0.0) },
            new List<Point> { new Point(5.0, -2.0), new Point(-3.0, -2.0), new Point(-2.0, 5.0),
                             new Point(1.0, 6.0), new Point(0.0, 2.0) },
            new List<Point> { new Point(0.0, 0.0), new Point(-2.0, -1.0), new Point(3.0, -4.0), new Point(2.0, 8.0),
                             new Point(3.0, 11.0), new Point(-8.0, -2.0), new Point(-14.0, -6.0),
                             new Point(7.0, 3.0), new Point(10.0, 4.0), new Point(-1.0, 4.0) }
        };

        foreach (var test in tests)
        {
            Circle circle = WelzlAlgorithm(test);
            Console.WriteLine($"Centre: ({circle.Centre.X}, {circle.Centre.Y}), Radius: {circle.Radius}");
        }
    }

    // Return the smallest enclosing circle using Welzl's algorithm
    private static Circle WelzlAlgorithm(List<Point> points)
    {
        var pointsCopy = new List<Point>(points);
        Shuffle(pointsCopy);
        return WelzlAlgorithmRecursive(pointsCopy, new List<Point>());
    }

    private static Circle WelzlAlgorithmRecursive(List<Point> aPoints, List<Point> aBoundary)
    {
        var points = new List<Point>(aPoints);
        var boundary = new List<Point>(aBoundary);

        // Base case occurs when all the points have been processed
        // or the smallest enclosing circle boundary is specified by three points
        if (points.Count == 0 || boundary.Count == 3)
        {
            return CircleFromListPoints(boundary);
        }

        // Choose a random point from the given 'points', since 'points' has already been shuffled
        Point point = points[points.Count - 1];
        points.RemoveAt(points.Count - 1);

        // Recurse with the chosen point removed
        Circle candidate = WelzlAlgorithmRecursive(points, boundary);

        if (Encloses(point, candidate))
        {
            return candidate;
        }

        // Otherwise, 'point' must be on the boundary of the smallest enclosing circle
        boundary.Add(point);

        // Recurse with the chosen point removed from 'points' and added to the 'boundary'
        return WelzlAlgorithmRecursive(points, boundary);
    }

    private static Circle CircleFromListPoints(List<Point> points)
    {
        return points.Count switch
        {
            0 => new Circle(new Point(0.0, 0.0), 0.0),
            1 => new Circle(points[0], 0.0),
            2 => CircleFromTwoPoints(points[0], points[1]),
            3 => CircleFromThreePoints(points[0], points[1], points[2]),
            _ => throw new InvalidOperationException($"There should be three or fewer points: {points.Count}")
        };
    }

    private static Circle CircleFromThreePoints(Point a, Point b, Point c)
    {
        Point ba = new Point(b.X - a.X, b.Y - a.Y);
        Point ca = new Point(c.X - a.X, c.Y - a.Y);
        double bb = ba.X * ba.X + ba.Y * ba.Y;
        double cc = ca.X * ca.X + ca.Y * ca.Y;
        double dd = (ba.X * ca.Y - ba.Y * ca.X) * 2.0;
        double centreX = (ca.Y * bb - ba.Y * cc) / dd + a.X;
        double centreY = (ba.X * cc - ca.X * bb) / dd + a.Y;
        Point centre = new Point(centreX, centreY);
        return new Circle(centre, Distance(a, centre));
    }

    private static Circle CircleFromTwoPoints(Point a, Point b)
    {
        return new Circle(new Point((a.X + b.X) / 2.0, (a.Y + b.Y) / 2.0), Distance(a, b) / 2.0);
    }

    private static bool Encloses(Point point, Circle circle)
    {
        return Distance(point, circle.Centre) <= circle.Radius;
    }

    private static double Distance(Point a, Point b)
    {
        return Math.Sqrt(Math.Pow(a.X - b.X, 2) + Math.Pow(a.Y - b.Y, 2));
    }

    // Helper method to shuffle a list (C# doesn't have Collections.shuffle)
    private static void Shuffle<T>(List<T> list)
    {
        Random rng = new Random();
        int n = list.Count;
        while (n > 1)
        {
            n--;
            int k = rng.Next(n + 1);
            (list[k], list[n]) = (list[n], list[k]);
        }
    }

    public record Point(double X, double Y);
    public record Circle(Point Centre, double Radius);
}
