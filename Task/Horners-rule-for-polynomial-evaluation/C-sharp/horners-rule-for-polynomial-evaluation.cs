using System;
using System.Linq;

class Program
{
    static double Horner(double[] coefficients, double variable)
    {
        return coefficients.Reverse().Aggregate(
                (accumulator, coefficient) => accumulator * variable + coefficient);
    }

    static void Main()
    {
        Console.WriteLine(Horner(new[] { -19.0, 7.0, -4.0, 6.0 }, 3.0));
    }
}
