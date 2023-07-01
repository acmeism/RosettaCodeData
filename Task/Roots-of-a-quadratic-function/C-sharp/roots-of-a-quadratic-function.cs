using System;
using System.Numerics;

class QuadraticRoots
{
    static Tuple<Complex, Complex> Solve(double a, double b, double c)
    {
        var q = -(b + Math.Sign(b) * Complex.Sqrt(b * b - 4 * a * c)) / 2;
        return Tuple.Create(q / a, c / q);
    }

    static void Main()
    {
        Console.WriteLine(Solve(1, -1E20, 1));
    }
}
