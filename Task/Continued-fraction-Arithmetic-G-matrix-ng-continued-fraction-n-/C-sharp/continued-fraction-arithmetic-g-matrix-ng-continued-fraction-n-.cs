using System.Numerics;
using Seq = System.Collections.Generic.IEnumerable<System.Numerics.BigInteger>;

static Seq Rep(BigInteger n) { while(true) yield return n; }

static Seq Cons(BigInteger n, Seq s) => new[]{n}.Concat(s);

static void Write(Seq terms)
{
    var ts = terms.ToArray();

    switch (ts.Length)
    {
        case 0: Console.Write("[]"); break;
        case 1: Console.Write($"[{ts[0]}]"); break;
        default:
            Console.Write($"[{ts[0]}; ");
            Console.Write(string.Join(", ", ts[1..]));
            Console.Write(']');
            break;
    }
}

static Seq Transform(Seq terms, BigInteger a1, BigInteger a, BigInteger b1, BigInteger b)
{
    foreach (var term in terms)
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

Console.Write("[1; 5, 2] + 1/2 = ");
Write(Transform([1, 5, 2], 2, 1, 0, 2));
Console.WriteLine();

Console.Write("[3; 7] + 1/2 = ");
Write(Transform([3, 7], 2, 1, 0, 2));
Console.WriteLine();

Console.Write("[3; 7] / 4 = ");
Write(Transform([3, 7], 1, 0, 0, 4));
Console.WriteLine();

var sqrt2 = Cons(1, Rep(2));
var oneOverSqrt2 = Transform(sqrt2, 0, 1, 1, 0);
var agm = Transform(oneOverSqrt2, 1, 1, 0, 2);
Console.Write("(1 + 1/sqrt(2)) / 2 = ");
Write(agm.Take(20));
Console.WriteLine();
