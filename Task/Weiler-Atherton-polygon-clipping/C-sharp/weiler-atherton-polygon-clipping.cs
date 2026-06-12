using System;
using System.Collections.Generic;
using System.Linq;

namespace PolygonClipper
{
    public struct Point : IEquatable<Point>
    {
        public int X { get; }
        public int Y { get; }

        public Point(int x, int y)
        {
            X = x;
            Y = y;
        }

        public bool Equals(Point other) => X == other.X && Y == other.Y;
        public override bool Equals(object obj) => obj is Point other && Equals(other);
        public override int GetHashCode() => HashCode.Combine(X, Y);
    }

    public struct Line
    {
        public Point Start { get; }
        public Point End { get; }

        public Line(Point start, Point end)
        {
            Start = start;
            End = end;
        }
    }

    public class Polygon
    {
        public List<Point> Points { get; }

        public Polygon(List<Point> points)
        {
            Points = points;
        }
    }

    public enum InterVertexType
    {
        InsideVertex,
        OutsideVertex,
        InIntersection,
        OutIntersection
    }

    public class InterVertex
    {
        public InterVertexType Type { get; }
        public Point Point { get; }

        public InterVertex(InterVertexType type, Point point)
        {
            Type = type;
            Point = point;
        }

        public static Point? GetFirstInIntersection(List<InterVertex> list)
        {
            for (int i = 0; i < list.Count; i++)
            {
                if (list[i].Type == InterVertexType.InIntersection)
                {
                    if (i > 0)
                    {
                        list.RemoveRange(0, i);
                    }
                    return list[0].Point;
                }
            }
            return null;
        }
    }

    public enum PolyListOptionType
    {
        List,
        InsidePoly,
        None
    }

    public class PolyListOption
    {
        public PolyListOptionType Type { get; }
        public List<InterVertex> InterVertexList { get; }
        public List<Point> Points { get; }

        public PolyListOption(PolyListOptionType type, List<InterVertex> interVertexList, List<Point> points)
        {
            Type = type;
            InterVertexList = interVertexList;
            Points = points;
        }
    }

    public static class PolygonClipper
    {
        public static bool IsInPolygon(Point point, Polygon poly)
        {
            int x = point.X;
            int y = point.Y;
            bool inside = false;
            int j = poly.Points.Count - 1;

            for (int i = 0; i < poly.Points.Count; i++)
            {
                int xi = poly.Points[i].X;
                int yi = poly.Points[i].Y;
                int xj = poly.Points[j].X;
                int yj = poly.Points[j].Y;

                bool intersect = ((yi > y) != (yj > y)) &&
                                (x < (double)(xj - xi) * (y - yi) / (yj - yi) + xi);

                if (intersect) inside = !inside;
                j = i;
            }

            return inside;
        }

        public static int DistanceCompare(Point self, Point first, Point second)
        {
            int dstFirst = Math.Abs(self.X - first.X) + Math.Abs(self.Y - first.Y);
            int dstSecond = Math.Abs(self.X - second.X) + Math.Abs(self.Y - second.Y);

            return dstFirst.CompareTo(dstSecond);
        }

        public static bool IsInLine(Point point, Line line)
        {
            int dxc = point.X - line.Start.X;
            int dyc = point.Y - line.Start.Y;
            int dxl = line.End.X - line.Start.X;
            int dyl = line.End.Y - line.Start.Y;
            int cross = dxc * dyl - dyc * dxl;

            if (cross != 0) return false;

            if (Math.Abs(dxl) >= Math.Abs(dyl))
            {
                return dxl > 0
                    ? line.Start.X <= point.X && point.X <= line.End.X
                    : line.End.X <= point.X && point.X <= line.Start.X;
            }
            return dyl > 0
                ? line.Start.Y <= point.Y && point.Y <= line.End.Y
                : line.End.Y <= point.Y && point.Y <= line.Start.Y;
        }

        public static Point? GetIntersection(Line self, Line line)
        {
            Point line1Start = self.Start;
            Point line1End = self.End;
            Point line2Start = line.Start;
            Point line2End = line.End;

            int den = (line2End.Y - line2Start.Y) * (line1End.X - line1Start.X) -
                      (line2End.X - line2Start.X) * (line1End.Y - line1Start.Y);

            if (den == 0) return null;

            int a = line1Start.Y - line2Start.Y;
            int b = line1Start.X - line2Start.X;
            int num1 = (line2End.X - line2Start.X) * a - (line2End.Y - line2Start.Y) * b;
            int num2 = (line1End.X - line1Start.X) * a - (line1End.Y - line1Start.Y) * b;
            double aF = (double)num1 / den;
            double bF = (double)num2 / den;

            if (aF < 0 || aF > 1 || bF < 0 || bF > 1) return null;

            return new Point(
                line1Start.X + (int)Math.Round(aF * (line1End.X - line1Start.X)),
                line1Start.Y + (int)Math.Round(aF * (line1End.Y - line1Start.Y))
            );
        }

        public static bool IsClockwise(Polygon poly)
        {
            int sum = 0;
            for (int i = 0; i < poly.Points.Count; i++)
            {
                int j = (i + 1) % poly.Points.Count;
                sum += (poly.Points[j].X - poly.Points[i].X) * (poly.Points[j].Y + poly.Points[i].Y);
            }
            return sum < 0;
        }

        public static Polygon GetReversed(Polygon poly)
        {
            List<Point> reversed = new List<Point>(poly.Points);
            reversed.Reverse();
            return new Polygon(reversed);
        }

        public static int? GetFirstOutsideVertexIndex(Polygon subject, Polygon poly)
        {
            for (int i = 0; i < subject.Points.Count; i++)
                if (!IsInPolygon(subject.Points[i], poly))
                    return i;
            return null;
        }

        public static int? GetFirstInsideVertexIndex(Polygon subject, Polygon poly)
        {
            for (int i = 0; i < subject.Points.Count; i++)
                if (IsInPolygon(subject.Points[i], poly))
                    return i;
            return null;
        }

        public static List<InterVertex> GetIntersectionsWithLine(Polygon poly, Line line, ref bool cursorInside)
        {
            List<Point> intersections = new List<Point>();
            for (int i = 0; i < poly.Points.Count; i++)
            {
                int nextI = (i + 1) % poly.Points.Count;
                Line edge = new Line(poly.Points[i], poly.Points[nextI]);
                Point? intersection = GetIntersection(edge, line);

                if (intersection.HasValue &&
                    !intersection.Value.Equals(line.Start) &&
                    !intersection.Value.Equals(line.End) &&
                    !intersection.Value.Equals(edge.Start) &&
                    !intersection.Value.Equals(edge.End))
                {
                    intersections.Add(intersection.Value);
                }
            }

            intersections.Sort((a, b) => DistanceCompare(line.Start, a, b));
            List<InterVertex> result = new List<InterVertex>();
            foreach (Point p in intersections)
            {
                if (cursorInside)
                {
                    cursorInside = false;
                    result.Add(new InterVertex(InterVertexType.OutIntersection, p));
                }
                else
                {
                    cursorInside = true;
                    result.Add(new InterVertex(InterVertexType.InIntersection, p));
                }
            }
            return result;
        }

        public static PolyListOption GetInterVertexList(Polygon subject, Polygon poly)
        {
            Polygon subjectCopy = IsClockwise(subject) ? subject : GetReversed(subject);
            bool cursorInside = false;

            int? startIndex = GetFirstOutsideVertexIndex(subjectCopy, poly);
            if (!startIndex.HasValue)
                return new PolyListOption(PolyListOptionType.InsidePoly, new List<InterVertex>(), subjectCopy.Points);

            if (!GetFirstInsideVertexIndex(subjectCopy, poly).HasValue)
            {
                bool allInside = poly.Points.All(p => IsInPolygon(p, subjectCopy));
                if (allInside)
                    return new PolyListOption(PolyListOptionType.InsidePoly, new List<InterVertex>(), poly.Points);
            }

            List<InterVertex> interVertices = new List<InterVertex>();
            for (int offset = 0; offset < subjectCopy.Points.Count; offset++)
            {
                int i = (startIndex.Value + offset) % subjectCopy.Points.Count;
                Point current = subjectCopy.Points[i];
                bool isInside = i != startIndex && IsInPolygon(current, poly);

                interVertices.Add(new InterVertex(
                    isInside ? InterVertexType.InsideVertex : InterVertexType.OutsideVertex,
                    current
                ));

                Point next = subjectCopy.Points[(i + 1) % subjectCopy.Points.Count];
                Line edge = new Line(current, next);
                interVertices.AddRange(GetIntersectionsWithLine(poly, edge, ref cursorInside));
            }

            bool hasIntersections = interVertices.Any(v =>
                v.Type == InterVertexType.InIntersection ||
                v.Type == InterVertexType.OutIntersection);

            return hasIntersections
                ? new PolyListOption(PolyListOptionType.List, interVertices, new List<Point>())
                : new PolyListOption(PolyListOptionType.None, new List<InterVertex>(), new List<Point>());
        }

        private class PointsPair
        {
            public List<Point> Points { get; }
            public Point LastPoint { get; }

            public PointsPair(List<Point> points, Point lastPoint)
            {
                Points = points;
                LastPoint = lastPoint;
            }
        }

        private static PointsPair CollectFromList(List<InterVertex> list, Point startPoint)
        {
            bool dontSkip = list[0].Point.Equals(startPoint);
            int startI = 0, endI = 0;

            if (!dontSkip)
            {
                for (int i = 0; i < list.Count; i++)
                {
                    int next = (i + 1) % list.Count;
                    if (list[next].Type == InterVertexType.InIntersection ||
                        list[next].Type == InterVertexType.OutIntersection)
                    {
                        if (list[next].Point.Equals(startPoint))
                        {
                            startI = next;
                            break;
                        }
                    }
                }
            }

            List<Point> points = new List<Point>();
            Point? lastPoint = null;
            for (int i = startI; i < list.Count; i++)
            {
                InterVertex vertex = list[i];
                if (vertex.Type == InterVertexType.OutIntersection)
                {
                    endI = i;
                    lastPoint = vertex.Point;
                    break;
                }
                points.Add(vertex.Point);
            }

            if (!lastPoint.HasValue) return null;

            int count = endI - startI + 1;
            list.RemoveRange(startI, count);
            return new PointsPair(points, lastPoint.Value);
        }

        private static List<Point> GetClipPolygon(
            List<InterVertex> subject,
            List<InterVertex> clip,
            Point initial)
        {
            List<Point> result = new List<Point>();
            bool useSubject = true;
            Point startPoint = initial;
            Point endPoint = subject[1].Point;

            while (!initial.Equals(endPoint))
            {
                PointsPair pair = CollectFromList(useSubject ? subject : clip, startPoint);
                if (pair == null) break;

                endPoint = pair.LastPoint;
                startPoint = pair.LastPoint;
                useSubject = !useSubject;
                result.AddRange(pair.Points);
            }

            List<Point> filtered = new List<Point>();
            for (int i = 0; i < result.Count; i++)
                if (i == 0 || !result[i].Equals(result[i - 1]))
                    filtered.Add(result[i]);

            return filtered;
        }

        public static List<List<Point>> GetClipPolygons(
            List<InterVertex> subject,
            List<InterVertex> clip)
        {
            List<List<Point>> polygons = new List<List<Point>>();
            while (true)
            {
                Point? startPoint = InterVertex.GetFirstInIntersection(subject);
                if (!startPoint.HasValue) break;

                List<Point> poly = GetClipPolygon(subject, clip, startPoint.Value);
                if (poly == null) break;
                polygons.Add(poly);
            }
            return polygons;
        }

        public static List<List<Point>> Clip(Polygon self, Polygon other)
        {
            PolyListOption selfOption = GetInterVertexList(self, other);
            PolyListOption otherOption = GetInterVertexList(other, self);

            if (selfOption.Type == PolyListOptionType.List)
            {
                if (otherOption.Type == PolyListOptionType.List)
                    return GetClipPolygons(selfOption.InterVertexList, otherOption.InterVertexList);
                if (otherOption.Type == PolyListOptionType.InsidePoly)
                    return new List<List<Point>> { otherOption.Points };
            }
            else if (selfOption.Type == PolyListOptionType.InsidePoly)
            {
                return new List<List<Point>> { selfOption.Points };
            }
            return new List<List<Point>>();
        }

        public static void RunTests()
        {
            // Test IsInLine
            Point p = new Point(5, 10);
            Line line = new Line(new Point(5, 5), new Point(5, 20));
            Console.WriteLine("isInLine test 1: " + (IsInLine(p, line) ? "PASS" : "FAIL"));

            Point pF = new Point(3, 4);
            Console.WriteLine("isInLine test 2: " + (!IsInLine(pF, line) ? "PASS" : "FAIL"));

            // Test Clip
            Polygon poly = new Polygon(new List<Point>
            {
                new Point(180, 420),
                new Point(180, 120),
                new Point(520, 120),
                new Point(520, 420),
                new Point(420, 420),
                new Point(320, 220)
            });

            Polygon interPoly = new Polygon(new List<Point>
            {
                new Point(60, 220),
                new Point(330, 120),
                new Point(410, 290),
                new Point(80, 480),
                new Point(280, 280)
            });

            List<List<Point>> polygons = Clip(poly, interPoly);
            if (polygons.Count > 0)
            {
                Console.WriteLine($"clip test: PASS - Found {polygons.Count} polygons");
                Console.WriteLine("First polygon points:");
                foreach (Point pt in polygons[0])
                    Console.WriteLine($"  ({pt.X}, {pt.Y})");
            }
            else
            {
                Console.WriteLine("clip test: FAIL");
            }
        }

        public static void Main(string[] args)
        {
            RunTests();
        }
    }
}
