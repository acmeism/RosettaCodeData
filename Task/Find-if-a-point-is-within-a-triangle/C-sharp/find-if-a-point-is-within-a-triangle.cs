using System.Numerics;

Point a = new(new(1, 10), new(1, 9));   // 0.1, 0.1111...
Point b = new(12.5, new(100, 3));       // 12.5, 33.3333...
Point c = new(25, new(100, 9));         // 25, 11.1111...

// Test a point on the boundary (supposedly fails with double-precision)
Point test = (4 * a + 3 * b) / 7;
test.IsInTriangle(a, b, c);

// Other examples
a = new(1.5, 2.4); b = new(5.1, -3.1); c = new(-3.8, 1.2);
new Point(0, 0).IsInTriangle(a, b, c);
new Point(0, 1).IsInTriangle(a, b, c);
new Point(3, 1).IsInTriangle(a, b, c);

record Point(Rational X, Rational Y)
{
    public static Point operator +(Point a, Point b) => new(a.X + b.X, a.Y + b.Y);
    public static Point operator -(Point a, Point b) => new(a.X - b.X, a.Y - b.Y);
    public static Point operator *(int s, Point p) => new(s * p.X, s * p.Y);
    public static Point operator /(Point p, int s) => new(p.X / s, p.Y / s);
    public override string ToString() => $"({X}, {Y})";

    public Rational Det(Point other) => X * other.Y - Y * other.X;

    public bool IsInTriangle(Point a, Point b, Point c)
    {
        var v1 = b - a;
        var v2 = c - a;
        var d = v1.Det(v2);
        var t = (Det(v2) - a.Det(v2)) / d;
        var u = (a.Det(v1) - Det(v1)) / d;
        var inside = t >= 0 && u >= 0 && 1 >= t + u;
        Console.WriteLine($"{this} in {a}, {b}, {c} = {inside}");
        return inside;
    }
}

readonly struct Rational
{
    public readonly BigInteger n, d;

    public Rational(BigInteger n, BigInteger d)
    {
        var g = BigInteger.GreatestCommonDivisor(n, d) * d.Sign;
        this.n = n / g; this.d = d / g;
    }

    public static implicit operator Rational(int n) => new(n, 1);
    public static implicit operator Rational(BigInteger n) => new(n, 1);
    public static Rational operator +(Rational x, Rational y) => new(x.n * y.d + y.n * x.d, x.d * y.d);
    public static Rational operator -(Rational x) => new(-x.n, x.d);
    public static Rational operator -(Rational x, Rational y) => new(x.n * y.d - y.n * x.d, x.d * y.d);
    public static Rational operator *(Rational x, Rational y) => new(x.n * y.n, x.d * y.d);
    public static Rational operator /(Rational x, Rational y) => new(x.n * y.d, x.d * y.n);
    public static bool operator >=(Rational x, Rational y) => x.n * y.d >= y.n * x.d;
    public static bool operator <=(Rational x, Rational y) => x.n * y.d <= y.n * x.d;
    public override readonly string ToString() => n == 0 ? "0" : d == 1 ? $"{n}" : $"{n}/{d}";

    public static implicit operator Rational(double d)
    {
        if (d == 0.0)
            return 0;

        long n = BitConverter.DoubleToInt64Bits(d);
        bool negative = n < 0;
        int exp = (int)(n >> 52) & 0x7FF;
        long mantissa = n & 0xFFFFFFFFFFFFF;

        if (exp == 0)
        {
            exp = -1022;
        }
        else
        {
            mantissa |= 0x10000000000000;
            exp -= 1023;
        }

        exp -= 52;
        long numerator = mantissa;
        if (negative) numerator = -numerator;

        if (exp >= 0)
            return new(numerator << exp, 1);

        return new(numerator, BigInteger.Pow(2, -exp));
    }
}
