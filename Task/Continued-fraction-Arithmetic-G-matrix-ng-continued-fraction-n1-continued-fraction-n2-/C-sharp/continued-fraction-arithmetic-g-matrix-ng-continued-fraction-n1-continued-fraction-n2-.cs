using System.Collections;
using System.Numerics;
using Seq = System.Collections.Generic.IEnumerable<System.Numerics.BigInteger>;

Console.WriteLine("Ratios");
Console.WriteLine($"\t13/11 = {CF.Ratio(13, 11)}");
Console.WriteLine($"\t22/7 = {CF.Ratio(22, 7)}");

Console.WriteLine("Square roots");
var phi = CF.Generate(() => 1);
Console.WriteLine($"\tphi = {phi}");
Console.WriteLine($"\t(1+√5)/2 = {(1 + CF.Sqrt(5)) / 2}");
var sqrt2 = CF.Sqrt(2);
Console.WriteLine($"\t√2 = {sqrt2}");
Console.WriteLine($"\t2√2 = {2 * sqrt2}");

for (var i = 3; i < 10; i++)
{
    Console.WriteLine($"\t√{i} = {CF.Sqrt(i)}");
}

Console.WriteLine("Irrational results");
var sqrt3 = CF.Sqrt(3);
Console.WriteLine($"\t√3 + √2 = {sqrt3 + sqrt2}");
Console.WriteLine($"\t√3 - √2 = {sqrt3 - sqrt2}");
Console.WriteLine($"\t√3 * √2 = {sqrt3 * sqrt2}");
Console.WriteLine($"\t√3 / √2 = {sqrt3 / sqrt2}");
Console.WriteLine("Rational results");
Console.WriteLine($"\t√2 - √2 = {sqrt2 - sqrt2}");
Console.WriteLine($"\t√2 * √2 = {sqrt2 * sqrt2}");
Console.WriteLine($"\t√2 / √2 = {sqrt2 / sqrt2}");

readonly struct CF : Seq
{
    public static readonly CF One = (CF)1;

    readonly Seq seq;

    public CF(Seq s)
    {
        var arr = s.Take(2).ToArray();

        if (arr.Length > 1 && arr[1] < 0)
            seq = Negate(s);
        else
            seq = s;
    }

    public IEnumerator<BigInteger> GetEnumerator() => seq.GetEnumerator();

    IEnumerator IEnumerable.GetEnumerator() => GetEnumerator();

    public CF(Func<Seq> f) : this(f()) { }

    public override string ToString()
    {
        var s = new StringWriter();
        s.Write('[');
        var n = 0;

        foreach (var t in seq.Take(21))
        {
            if (n == 20) { s.Write(", ..."); break; }
            if (n == 1) s.Write("; ");
            else if (n > 1) s.Write(", ");
            s.Write(t);
            n++;
        }

        s.Write(']');
        return s.ToString();
    }

    static Seq Just(BigInteger n) { yield return n; }

    public static explicit operator CF(int n) => new(Just(n));

    public static explicit operator CF(BigInteger n) => new(Just(n));

    public static CF Ratio(BigInteger n, BigInteger d) =>
        n.Sign * d.Sign >= 0 ? new(One.Transform(n, 0, d, 0)) : -new CF(One.Transform(-n, 0, d, 0));

    static Seq GenerateSeq(Func<BigInteger> generator)
    {
        while (true) yield return generator();
    }

    public static CF Generate(Func<BigInteger> generator) => new(GenerateSeq(generator));

    Seq Transform(BigInteger a1, BigInteger a, BigInteger b1, BigInteger b)
    {
        foreach (var term in seq)
        {
            (a, a1) = (a1, a + term * a1);
            (b, b1) = (b1, b + term * b1);

            while (!b1.IsZero && !b.IsZero)
            {
                var m = BigInteger.DivRem(a1, b1, out var r);
                var n = BigInteger.DivRem(a, b, out var s);

                if (m != n)
                    break;

                yield return n;
                (a1, b1) = (b1, r);
                (a, b) = (b, s);
            }
        }

        while (!a1.IsZero && !b1.IsZero)
        {
            var n = BigInteger.DivRem(a1, b1, out var s);
            yield return n;
            (a1, b1) = (b1, s);
        }
    }

    static Seq AddInt(BigInteger n, CF cf)
    {
        yield return n + cf.First();

        foreach (var term in cf.Skip(1))
            yield return term;
    }

    static Seq Negate(Seq seq)
    {
        var arr = seq.Take(3).ToArray();

        if (arr.Length == 0)
            return [];

        if (arr.Length == 1)
            return [-arr[0]];

        if (arr[1] == BigInteger.One)
            return new[] { -arr[0] - BigInteger.One, arr[2] + BigInteger.One }.Concat(seq.Skip(3));

        return new[] { -arr[0] - BigInteger.One, BigInteger.One, arr[1] - BigInteger.One }.Concat(seq.Skip(2));
    }

    public static CF operator -(CF cf) => new(Negate(cf.seq));
    public static CF operator +(BigInteger a, CF b) => new(AddInt(a, b));
    public static CF operator +(CF a, BigInteger b) => new(AddInt(b, a));
    public static CF operator -(BigInteger a, CF b) => new(AddInt(-a, b));
    public static CF operator -(CF a, BigInteger b) => new(AddInt(-b, a));
    public static CF operator *(BigInteger n, CF d) => new(d.Transform(n, 0, 0, 1));
    public static CF operator *(CF n, BigInteger d) => new(n.Transform(d, 0, 0, 1));
    public static CF operator /(BigInteger n, CF d) => new(d.Transform(0, n, 1, 0));
    public static CF operator /(CF n, BigInteger d) => new(n.Transform(1, 0, 0, d));

    private static BigInteger FloorSqrt(BigInteger n)
    {
        var guess = BigInteger.One;
        BigInteger two = 2;

        while (true)
        {
            var newGuess = (n / guess + guess) >> 1;

            if (guess == newGuess)
                return guess;

            if (BigInteger.Abs(guess - newGuess) < two)
            {
                var sign1 = (guess * guess - n).Sign;
                var sign2 = (newGuess * newGuess - n).Sign;

                if (sign1 * sign2 == -1)
                    return BigInteger.Min(guess, newGuess);
            }

            guess = newGuess;
        }
    }

    static Seq SqrtSeq(BigInteger S)
    {
        ArgumentOutOfRangeException.ThrowIfLessThan(S, BigInteger.Zero, nameof(S));

        BigInteger a0 = FloorSqrt(S);
        yield return a0;

        if (a0 * a0 == S)
            yield break;

        BigInteger m = 0;
        BigInteger d = 1;
        BigInteger a = a0;

        while (true)
        {
            m = d * a - m;
            d = (S - m * m) / d;
            a = (a0 + m) / d;
            yield return a;
        }
    }

    public static CF Sqrt(BigInteger n) => new(SqrtSeq(n));

    static Seq Transform(
            Seq x, Seq y,
            BigInteger a12, BigInteger a1, BigInteger a2, BigInteger a,
            BigInteger b12, BigInteger b1, BigInteger b2, BigInteger b)
    {
        using var ea = x.GetEnumerator();
        var ha = ea.MoveNext();
        using var eb = y.GetEnumerator();
        var hb = eb.MoveNext();
        var count = 0;

        while (ha && hb)
        {
            var p = ea.Current;
            (a, a1) = (a1, a + a1 * p);
            (a2, a12) = (a12, a2 + a12 * p);
            (b, b1) = (b1, b + b1 * p);
            (b2, b12) = (b12, b2 + b12 * p);
            ha = ea.MoveNext();

            var q = eb.Current;
            (a, a2) = (a2, a + a2 * q);
            (a1, a12) = (a12, a1 + a12 * q);
            (b, b2) = (b2, b + b2 * q);
            (b1, b12) = (b12, b1 + b12 * q);
            hb = eb.MoveNext();

            if (b.IsZero && b1.IsZero && b2.IsZero && b12.IsZero)
                yield break;

            while (!b.IsZero && !b1.IsZero && !b2.IsZero && !b12.IsZero)
            {
                var q0 = BigInteger.DivRem(a, b, out var r0);
                var q1 = BigInteger.DivRem(a1, b1, out var r1);
                var q2 = BigInteger.DivRem(a2, b2, out var r2);
                var q3 = BigInteger.DivRem(a12, b12, out var r3);

                if (q0 != q1 || q0 != q2 || q0 != q3)
                    break;

                yield return q0;
                count = 0;
                (a, b) = (b, r0);
                (a1, b1) = (b1, r1);
                (a2, b2) = (b2, r2);
                (a12, b12) = (b12, r3);
            }

            if (++count >= 1000)
                goto abort;
        }

        while (ha)  // the rest of y is infinite, a, b, e, f don't matter, calculate (c + dx) / (g + hx)
        {
            var p = ea.Current;
            (a2, a12) = (a12, a2 + a12 * p);
            (b2, b12) = (b12, b2 + b12 * p);
            ha = ea.MoveNext();

            if (b2.IsZero && b12.IsZero)
                yield break;

            while (!b2.IsZero && !b12.IsZero)
            {
                var q2 = BigInteger.DivRem(a2, b2, out var r2);
                var q3 = BigInteger.DivRem(a12, b12, out var r3);

                if (q2 != q3)
                    break;

                yield return q2;
                (a2, b2) = (b2, r2);
                (a12, b12) = (b12, r3);
            }
        }

        while (hb)  // rest of x is infinite, a, c, e, g don't matter, calculate (b + dy) / (f + hy)
        {
            var q = eb.Current;
            (a1, a12) = (a12, a1 + a12 * q);
            (b1, b12) = (b12, b1 + b12 * q);
            hb = eb.MoveNext();

            if (b1.IsZero && b12.IsZero)
                yield break;

            while (!b1.IsZero && !b12.IsZero)
            {
                var q1 = BigInteger.DivRem(a1, b1, out var r1);
                var q3 = BigInteger.DivRem(a12, b12, out var r3);

                if (q1 != q3)
                    break;

                yield return q1;
                (a1, b1) = (b1, r1);
                (a12, b12) = (b12, r3);
            }
        }

    abort:
        if (b12.IsZero)
            yield break;

        BigInteger? lastTerm = null;

        foreach (var term in Ratio(a12, b12))
        {
            if (lastTerm.HasValue)
                yield return lastTerm.Value;

            lastTerm = term;
        }

        if (lastTerm.HasValue && BigInteger.Log2(lastTerm.Value) < 100)
            yield return lastTerm.Value;
    }

    public static CF operator+(CF x, CF y) => new(Transform(x, y, 0, 1, 1, 0, 0, 0, 0, 1));
    public static CF operator-(CF x, CF y) => new(Transform(x, y, 0, 1, -1, 0, 0, 0, 0, 1));
    public static CF operator*(CF x, CF y) => new(Transform(x, y, 1, 0, 0, 0, 0, 0, 0, 1));
    public static CF operator/(CF x, CF y) => new(Transform(x, y, 0, 1, 0, 0, 0, 0, 1, 0));
}
