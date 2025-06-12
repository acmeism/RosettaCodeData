using System;
using System.Collections.Generic;

public sealed class EllipticCurveDigitalSignatureAlgorithm
{
    public static void Main(string[] args)
    {
        // Test parameters for elliptic curve digital signature algorithm,
        // using the short Weierstrass model: y^2 = x^3 + ax + b (mod N).
        //
        // Parameter: a, b, modulus N, base point G, order of G in the elliptic curve.

        List<Parameter> parameters = new List<Parameter>
        {
            new Parameter(355, 671, 1073741789, new Point(13693, 10088), 1073807281),
            new Parameter(0, 7, 67096021, new Point(6580, 779), 16769911),
            new Parameter(-3, 1, 877073, new Point(0, 1), 878159),
            new Parameter(0, 14, 22651, new Point(63, 30), 151),
            new Parameter(3, 2, 5, new Point(2, 1), 5)
        };

        // Parameters which cause failure of the algorithm for the given reasons
        // the base point is of composite order
        // new Parameter(0, 7, 67096021, new Point(2402, 6067), 33539822),
        // the given order is of composite order
        // new Parameter(0, 7, 67096021, new Point(6580, 779), 67079644),
        // the modulus is not prime (deceptive example)
        // new Parameter(0, 7, 877069, new Point(3, 97123), 877069),
        // fails if the modulus divides the discriminant
        // new Parameter(39, 387, 22651, new Point(95, 27), 22651)

        const long f = 0x789abcde; // The message's digital signature hash which is to be verified
        const int d = 0;           // Set d > 0 to simulate corrupted data

        foreach (Parameter parameter in parameters)
        {
            EllipticCurve ellipticCurve = new EllipticCurve(parameter);
            Ecdsa(ellipticCurve, f, d);
        }
    }

    // Build the digital signature for a message using the hash aF with error bit aD
    private static void Ecdsa(EllipticCurve aCurve, long aF, int aD)
    {
        Point point = aCurve.Multiply(aCurve.G, aCurve.R);

        if (aCurve.Discriminant() == 0 || aCurve.G.IsZero() || !point.IsZero() || !aCurve.Contains(aCurve.G))
        {
            throw new InvalidOperationException("Invalid parameter in method ecdsa");
        }

        Console.WriteLine(Environment.NewLine + "key generation");
        long s = 1 + (long)(Random() * (double)(aCurve.R - 1));
        point = aCurve.Multiply(aCurve.G, s);
        Console.WriteLine("private key s = " + s);
        aCurve.PrintPointWithPrefix(point, "public key W = sG");

        // Find the next highest power of two minus one.
        long t = aCurve.R;
        long i = 1;
        while (i < 64)
        {
            t |= t >> (int)i;
            i <<= 1;
        }
        long f = aF;
        while (f > t)
        {
            f >>= 1;
        }
        Console.WriteLine(Environment.NewLine + "aligned hash " + $"{f:x8}");

        Pair signature = Signature(aCurve, s, f);
        Console.WriteLine("signature c, d = " + signature.A + ", " + signature.B);

        long d = aD;
        if (d > 0)
        {
            while (d > t)
            {
                d >>= 1;
            }
            f ^= d;
            Console.WriteLine(Environment.NewLine + "corrupted hash " + $"{f:x8}");
        }

        Console.WriteLine(Verify(aCurve, point, f, signature) ? "Valid" : "Invalid");
        Console.WriteLine("-----------------");
    }

    private static bool Verify(EllipticCurve aCurve, Point aPoint, long aF, Pair aSignature)
    {
        if (aSignature.A < 1 || aSignature.A >= aCurve.R || aSignature.B < 1 || aSignature.B >= aCurve.R)
        {
            return false;
        }

        Console.WriteLine(Environment.NewLine + "signature verification");
        long h = ExtendedGCD(aSignature.B, aCurve.R);
        long h1 = FloorMod(aF * h, aCurve.R);
        long h2 = FloorMod(aSignature.A * h, aCurve.R);
        Console.WriteLine("h1, h2 = " + h1 + ", " + h2);
        Point v = aCurve.Multiply(aCurve.G, h1);
        Point v2 = aCurve.Multiply(aPoint, h2);
        aCurve.PrintPointWithPrefix(v, "h1G");
        aCurve.PrintPointWithPrefix(v2, "h2W");
        v = aCurve.Add(v, v2);
        aCurve.PrintPointWithPrefix(v, "+ =");

        if (v.IsZero())
        {
            return false;
        }
        long c1 = FloorMod(v.X, aCurve.R);
        Console.WriteLine("c' = " + c1);
        return c1 == aSignature.A;
    }

    private static Pair Signature(EllipticCurve aCurve, long aS, long aF)
    {
        long c = 0;
        long d = 0;
        long u;
        Point v;
        Console.WriteLine("Signature computation");

        while (true)
        {
            while (true)
            {
                u = 1 + (long)(Random() * (double)(aCurve.R - 1));
                v = aCurve.Multiply(aCurve.G, u);
                c = FloorMod(v.X, aCurve.R);
                if (c != 0)
                {
                    break;
                }
            }

            d = FloorMod(ExtendedGCD(u, aCurve.R) * FloorMod(aF + aS * c, aCurve.R), aCurve.R);
            if (d != 0)
            {
                break;
            }
        }

        Console.WriteLine("one-time u = " + u);
        aCurve.PrintPointWithPrefix(v, "V = uG");
        return new Pair(c, d);
    }

    // Return 1 / aV modulus aU
    private static long ExtendedGCD(long aV, long aU)
    {
        if (aV < 0)
        {
            aV += aU;
        }

        long result = 0;
        long s = 1;
        while (aV != 0)
        {
            long quotient = FloorDiv(aU, aV);
            aU = FloorMod(aU, aV);
            long temp = aU; aU = aV; aV = temp;
            result -= quotient * s;
            temp = result; result = s; s = temp;
        }

        if (aU != 1)
        {
            throw new InvalidOperationException("Cannot inverse modulo N, gcd = " + aU);
        }
        return result;
    }

    private static double Random()
    {
        return _random.NextDouble();
    }

    // C# implementation of Java's Math.floorMod
    private static long FloorMod(long x, long y)
    {
        return ((x % y) + y) % y;
    }

    // C# implementation of Java's Math.floorDiv
    private static long FloorDiv(long x, long y)
    {
        long r = x / y;
        if ((x ^ y) < 0 && (r * y != x))
        {
            r--;
        }
        return r;
    }

    private class EllipticCurve
    {
        public long A { get; }
        public long B { get; }
        public long N { get; }
        public long R { get; }
        public Point G { get; }

        public EllipticCurve(Parameter aParameter)
        {
            N = aParameter.N;
            if (N < 5 || N > MAX_MODULUS)
            {
                throw new InvalidOperationException("Invalid value for modulus: " + N);
            }

            A = FloorMod(aParameter.A, N);
            B = FloorMod(aParameter.B, N);
            G = aParameter.G;
            R = aParameter.R;

            if (R < 5 || R > MAX_ORDER_G)
            {
                throw new InvalidOperationException("Invalid value for the order of g: " + R);
            }

            Console.WriteLine();
            Console.WriteLine("Elliptic curve: y^2 = x^3 + " + A + "x + " + B + " (mod " + N + ")");
            PrintPointWithPrefix(G, "base point G");
            Console.WriteLine("order(G, E) = " + R);
        }

        public Point Add(Point aP, Point aQ)
        {
            if (aP.IsZero())
            {
                return aQ;
            }
            if (aQ.IsZero())
            {
                return aP;
            }

            long la;
            if (aP.X != aQ.X)
            {
                la = FloorMod((aP.Y - aQ.Y) * ExtendedGCD(aP.X - aQ.X, N), N);
            }
            else if (aP.Y == aQ.Y && aP.Y != 0)
            {
                la = FloorMod(FloorMod(FloorMod(
                    aP.X * aP.X, N) * 3 + A, N) * ExtendedGCD(2 * aP.Y, N), N);
            }
            else
            {
                return Point.ZERO;
            }

            long xCoordinate = FloorMod(la * la - aP.X - aQ.X, N);
            long yCoordinate = FloorMod(la * (aP.X - xCoordinate) - aP.Y, N);
            return new Point(xCoordinate, yCoordinate);
        }

        public Point Multiply(Point aPoint, long aK)
        {
            Point result = Point.ZERO;

            while (aK != 0)
            {
                if ((aK & 1) == 1)
                {
                    result = Add(result, aPoint);
                }
                aPoint = Add(aPoint, aPoint);
                aK >>= 1;
            }
            return result;
        }

        public bool Contains(Point aPoint)
        {
            if (aPoint.IsZero())
            {
                return true;
            }

            long r = FloorMod(FloorMod(A + aPoint.X * aPoint.X, N) * aPoint.X + B, N);
            long s = FloorMod(aPoint.Y * aPoint.Y, N);
            return r == s;
        }

        public long Discriminant()
        {
            long constant = 4 * FloorMod(A * A, N) * FloorMod(A, N);
            return FloorMod(-16 * (FloorMod(B * B, N) * 27 + constant), N);
        }

        public void PrintPointWithPrefix(Point aPoint, string aPrefix)
        {
            long y = aPoint.Y;
            if (aPoint.IsZero())
            {
                Console.WriteLine(aPrefix + " (0)");
            }
            else
            {
                if (y > N - y)
                {
                    y -= N;
                }
                Console.WriteLine(aPrefix + " (" + aPoint.X + ", " + y + ")");
            }
        }
    }

    private class Point
    {
        public long X { get; }
        public long Y { get; }

        public Point(long aX, long aY)
        {
            X = aX;
            Y = aY;
        }

        public bool IsZero()
        {
            return X == INFINITY && Y == 0;
        }

        private const long INFINITY = long.MaxValue;
        public static readonly Point ZERO = new Point(INFINITY, 0);
    }

    private class Pair
    {
        public long A { get; }
        public long B { get; }

        public Pair(long a, long b)
        {
            A = a;
            B = b;
        }
    }

    private class Parameter
    {
        public long A { get; }
        public long B { get; }
        public long N { get; }
        public Point G { get; }
        public long R { get; }

        public Parameter(long a, long b, long n, Point g, long r)
        {
            A = a;
            B = b;
            N = n;
            G = g;
            R = r;
        }
    }

    private const int MAX_MODULUS = 1073741789;
    private const int MAX_ORDER_G = MAX_MODULUS + 65536;

    private static readonly Random _random = new Random();
}
