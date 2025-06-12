using System.Numerics;

using Seq = System.Collections.Generic.IEnumerable<System.Numerics.BigInteger>;

static Seq Rep(BigInteger n) { while(true) yield return n; }

static Seq Cons(BigInteger n, Seq s) => new[]{n}.Concat(s);

static Seq Reciprocal(Seq s) => s.First() == 0 ? s.Skip(1) : Cons(0, s);

static Seq Nats() { BigInteger n = 1; while(true) { yield return n; n++; } }

static Seq Squared(Seq s) => s.Select(n => n * n);

static Seq Odds() => Nats().Select(n => 2 * n - 1);

static Seq Simplify(Seq aseq, Seq bseq)
{
    BigInteger a = 0, b = 1, c = 1, d = 0;
    using var e = bseq.GetEnumerator();

    foreach (var t in aseq)
    {
        var u = e.MoveNext() ? e.Current : 1;
        (a, b) = (u * b, a + t * b);
        (c, d) = (u * d, c + t * d);

        while (!c.IsZero && !d.IsZero)
        {
            var m = BigInteger.DivRem(a, c, out var r);
            var n = BigInteger.DivRem(b, d, out var s);

            if (m != n)
                break;

            yield return n;
            (a, c) = (c, r);
            (b, d) = (d, s);
        }
    }

    while (!b.IsZero && !d.IsZero)
    {
        var n = BigInteger.DivRem(b, d, out var s);
        yield return n;
        (b, d) = (d, s);
    }
}

static void Write(Seq terms, int places)
{
    Console.Write(terms.First());
    Console.Write('.');
    BigInteger a = 10, b = 0, c = 0, d = 1;

    foreach (var term in terms.Skip(1))
    {
        (a, b) = (b, a + b * term);
        (c, d) = (d, c + d * term);

        while (!c.IsZero && !d.IsZero)
        {
            var m = BigInteger.DivRem(a, c, out var r);
            var n = BigInteger.DivRem(b, d, out var s);

            if (m != n)
                break;

            Console.Write(m);

            if (--places <= 0)
                return;

            a = r * 10;
            b = s * 10;
        }
    }

    while (!b.IsZero && !d.IsZero)
    {
        var n = BigInteger.DivRem(b, d, out var s);
        Console.Write(n);

        if (--places <= 0)
            return;

        b = s * 10;
    }
}

static Seq Sqrt2() => Cons(1, Rep(2));

static Seq E() => Simplify(Cons(2, Nats()), Cons(1, Nats()));

static Seq Pi() => Simplify(Cons(3, Rep(6)), Squared(Odds()));

Write(Sqrt2(), 20);
Console.WriteLine();
Write(E(), 20);
Console.WriteLine();
Write(Pi(), 10);
Console.WriteLine();
