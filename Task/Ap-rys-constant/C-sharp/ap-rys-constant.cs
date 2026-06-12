using System.Numerics;
using System.Text;

var apery1 = Apery1(1000);
Console.WriteLine(apery1.ToDecimal(100));
var apery2 = Apery2(158);
Console.WriteLine(apery2.ToDecimal(100));
var apery3 = Apery3(20);
Console.WriteLine(apery3.ToDecimal(100));
var apery4 = Apery4(32);
Console.WriteLine(apery4.ToDecimal(100));

static Rational Apery1(int terms)
{
    Rational sum = 0;

    for (var k = 1; k <= terms; k++)
    {
        sum += new Rational(1, k * k * k);
    }

    return sum;
}

static Rational Apery2(int terms)
{
    Rational sum = 0;
    BigInteger kfactsqr = -1;
    BigInteger twokfact = 1;

    for (var k = 1; k <= terms; k++)
    {
        var kk = k * k;
        kfactsqr *= -kk;
        twokfact *= (2 * k - 1) * 2 * k;
        sum += new Rational(kfactsqr, twokfact * k * kk);
    }

    return sum * new Rational(5, 2);
}

static Rational Apery3(int terms)
{
    // For k = 0
    BigInteger n = 1;
    BigInteger d = 2 * 6 * 6 * 6;

    Rational sum = new(n * 12463, d);

    for (var k = 1; k < terms; k++)
    {
        // (2k+1)!³
        var tk1 = 2 * k + 1;
        n *= tk1 * tk1 * tk1;
        var k3 = k * k * k;
        var tkc = 8 * k3;
        n *= tkc;

        // (2k)!³
        n *= tkc;
        var tkm = 2 * k - 1;
        n *= tkm * tkm * tkm;

        // k!³
        n *= k3;

        // (3k+2)!
        d *= (3 * k + 2) * (3 * k + 1) * 3 * k;

        // (4k+3)!³
        var fk3 = 4 * k + 3;
        d *= fk3 * fk3 * fk3;
        fk3--;
        d *= fk3 * fk3 * fk3;
        fk3--;
        d *= fk3 * fk3 * fk3;
        fk3--;
        d *= fk3 * fk3 * fk3;

        // polynomial
        BigInteger b = k;
        var p = 12463 + b * (104000 + b * (336367 + b * (531578 + b * (412708 + b * 126392))));

        Rational term = new(n * p, d);
        if ((k & 1) == 1) term = -term;
        sum += term;
    }

    return sum / 24;
}

static Rational Apery4(int terms)
{
    BigInteger a(BigInteger n) => 5 + n * (27 + n * (51 + n * 34));
    BigInteger b(BigInteger n) => n * n * n * n * n * n;

    Rational r = a(terms);

    for (var n = terms - 1; n >= 0; n--)
    {
        r = a(n) - b(n + 1) / r;
    }

    return 6 / r;
}

readonly struct Rational
{
    public readonly BigInteger N;

    public readonly BigInteger D;

    public Rational(BigInteger n, BigInteger d)
    {
        ArgumentOutOfRangeException.ThrowIfEqual(d, 0, nameof(d));
        var g = BigInteger.GreatestCommonDivisor(n, d);
        (N, D) = (n / g, d / g);
        if (D < 0) { N = -N; D = -D; }
    }

    private Rational(BigInteger n, BigInteger d, bool _)
    {
        N = n;
        D = d;
    }

    public static implicit operator Rational(int n) =>
        new(n, 1, false);

    public static implicit operator Rational(BigInteger n) =>
        new(n, 1, false);

    public static Rational operator -(Rational q) =>
        new(-q.N, q.D, false);

    public static Rational operator +(Rational x, Rational y) =>
        new(x.N * y.D + x.D * y.N, x.D * y.D);

    public static Rational operator -(Rational x, Rational y) =>
        new(x.N * y.D - x.D * y.N, x.D * y.D);

    public static Rational operator *(Rational x, Rational y) =>
        new(x.N * y.N, x.D * y.D);

    public static Rational operator /(Rational x, Rational y) =>
        new(x.N * y.D, x.D * y.N);

    public BigInteger Floor() => N / D - (N < 0 ? 1 : 0);

    public string ToDecimal(int places)
    {
        if (N < 0)
            return "-" + (-this).ToDecimal(places);

        StringBuilder s = new();
        var f = Floor();
        s.Append(f);
        s.Append('.');
        var r = this - f;

        while (places-- > 0)
        {
            r *= 10;
            f = r.Floor();
            s.Append(f);
            r -= f;
        }

        return s.ToString();
    }
}
