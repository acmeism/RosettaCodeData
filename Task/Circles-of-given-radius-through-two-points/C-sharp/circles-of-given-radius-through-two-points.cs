using System;
public class CirclesOfGivenRadiusThroughTwoPoints
{
    public static void Main()
    {
        double[][] values = new double[][] {
            new [] { 0.1234, 0.9876, 0.8765, 0.2345,   2 },
            new [] { 0.0,       2.0,    0.0,    0.0,   1 },
            new [] { 0.1234, 0.9876, 0.1234, 0.9876,   2 },
            new [] { 0.1234, 0.9876, 0.8765, 0.2345, 0.5 },
            new [] { 0.1234, 0.9876, 0.1234, 0.9876,   0 }
        };
		
        foreach (var a in values) {
            var p = new Point(a[0], a[1]);
            var q = new Point(a[2], a[3]);
            Console.WriteLine($"Points {p} and {q} with radius {a[4]}:");
            try {
                var centers = FindCircles(p, q, a[4]);
                Console.WriteLine("\t" + string.Join(" and ", centers));
            } catch (Exception ex) {
                Console.WriteLine("\t" + ex.Message);
            }
        }
    }
	
    static Point[] FindCircles(Point p, Point q, double radius) {
        if(radius < 0) throw new ArgumentException("Negative radius.");
        if(radius == 0) {
            if(p == q) return new [] { p };
            else throw new InvalidOperationException("No circles.");
        }
        if (p == q) throw new InvalidOperationException("Infinite number of circles.");
		
        double sqDistance = Point.SquaredDistance(p, q);
        double sqDiameter = 4 * radius * radius;
        if (sqDistance > sqDiameter) throw new InvalidOperationException("Points are too far apart.");
		
        Point midPoint = new Point((p.X + q.X) / 2, (p.Y + q.Y) / 2);
        if (sqDistance == sqDiameter) return new [] { midPoint };
		
        double d = Math.Sqrt(radius * radius - sqDistance / 4);
        double distance = Math.Sqrt(sqDistance);
        double ox = d * (q.X - p.X) / distance, oy = d * (q.Y - p.Y) / distance;
        return new [] {
            new Point(midPoint.X - oy, midPoint.Y + ox),
            new Point(midPoint.X + oy, midPoint.Y - ox)
        };
    }
	
    public struct Point
    {
        public Point(double x, double y) : this() {
            X = x;
            Y = y;
        }
	
        public double X { get; }
        public double Y { get; }
	
        public static bool operator ==(Point p, Point q) => p.X == q.X && p.Y == q.Y;
        public static bool operator !=(Point p, Point q) => p.X != q.X || p.Y != q.Y;
	
        public static double SquaredDistance(Point p, Point q) {
            double dx = q.X - p.X, dy = q.Y - p.Y;
            return dx * dx + dy * dy;
        }
		
        public override string ToString() => $"({X}, {Y})";
		
    }	
}
