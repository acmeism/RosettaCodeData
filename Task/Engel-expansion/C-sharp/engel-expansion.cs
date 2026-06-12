using System.Numerics;

Write("3.14159265358979");
Write("2.71828182845904");
Write("1.414213562373095");
var e = 1 + FromEngel(Enumerable.Range(1, 30).Select(i => (BigInteger)i));
WriteR(e);

void Write(string s)
{
    Console.WriteLine($"Decimal rational: {s}");
    WriteR(Rational.Parse(s));
}

void WriteR(Rational r)
{
    var e = ToEngel(r).ToArray();
    Console.Write("Engel expansion:");

    foreach (var a in e)
    {
        Console.Write($" {a}");
    }

    Console.WriteLine();
    r = FromEngel(e);
    var d = Math.Exp(BigInteger.Log(r.n) - BigInteger.Log(r.d));
    Console.WriteLine($"Rational equivalent: {r}");
    Console.WriteLine($"Floating point approximation: {d}\n");
}

IEnumerable<BigInteger> ToEngel(Rational r)
{
    while (r != 0)
    {
        var a = (1 / r).Ceiling();
        yield return a;
        r = r * a - 1;
    }
}

Rational FromEngel(IEnumerable<BigInteger> e)
{
    Rational r = 0;
    Rational term = 1;

    foreach (var a in e)
    {
        term /= a;
        r += term;
    }

    return r;
}

readonly struct Rational
{
    public readonly BigInteger n, d;

    public Rational(BigInteger n, BigInteger d)
    {
        var g = BigInteger.GreatestCommonDivisor(n, d);
        this.n = n / g; this.d = d / g;
    }

    public static implicit operator Rational(int n) => new(n, 1);
    public static implicit operator Rational(BigInteger n) => new(n, 1);
    public static Rational operator +(Rational x, Rational y) => new(x.n * y.d + y.n * x.d, x.d * y.d);
    public static Rational operator -(Rational x, Rational y) => new(x.n * y.d - y.n * x.d, x.d * y.d);
    public static Rational operator *(Rational x, Rational y) => new(x.n * y.n, x.d * y.d);
    public static Rational operator /(Rational x, Rational y) => new(x.n * y.d, x.d * y.n);
    public static bool operator ==(Rational x, Rational y) => x.n == y.n && x.d == y.d;
    public static bool operator !=(Rational x, Rational y) => x.n != y.n || x.d != y.d;
    public override readonly string ToString() => n == 0 ? "0" : d == 1 ? $"{n}" : $"{n}/{d}";
    public BigInteger Ceiling() => (n + d - 1) / d;

    public static Rational Parse(string s)
    {
        var i = s.IndexOf('.');
        return new(BigInteger.Parse(s[..i] + s[(i + 1)..]), BigInteger.Pow(10, s.Length - i - 1));
    }
}
