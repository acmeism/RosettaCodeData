using System;
using System.Numerics;

static class Program
{
    static void Fun(ref BigInteger a, ref BigInteger b, int c)
    {
        BigInteger t = a; a = b; b = b * c + t;
    }

    static void SolvePell(int n, ref BigInteger a, ref BigInteger b)
    {
        int x = (int)Math.Sqrt(n), y = x, z = 1, r = x << 1;
        BigInteger e1 = 1, e2 = 0, f1 = 0, f2 = 1;
        while (true)
        {
            y = r * z - y; z = (n - y * y) / z; r = (x + y) / z;
            Fun(ref e1, ref e2, r); Fun(ref f1, ref f2, r); a = f2; b = e2; Fun(ref b, ref a, x);
            if (a * a - n * b * b == 1) return;
        }
    }

    static void Main()
    {
        BigInteger x, y; foreach (int n in new[] { 61, 109, 181, 277 })
        {
            SolvePell(n, ref x, ref y);
            Console.WriteLine("x^2 - {0,3} * y^2 = 1 for x = {1,27:n0} and y = {2,25:n0}", n, x, y);
        }
    }
}
