using System;
using System.Linq;
using System.Drawing;

public static class LagrangeInterpolation
{
    public static void Main(string[] args)
    {
        Point[] points = new Point[] { new Point(1, 1), new Point(2, 4), new Point(3, 1), new Point(4, 5) };

        Display(LagrangeInterpolationMethod(points));
    }

    private static double[] LagrangeInterpolationMethod(Point[] points)
    {
        double[][] polys = new double[points.Length][];
        for (int i = 0; i < points.Length; i++)
        {
            double[] poly = new double[] { 1.0 };
            for (int j = 0; j < points.Length; j++)
            {
                if (i != j)
                {
                    poly = Multiply(poly, new double[] { -points[j].X, 1.0 });
                }
            }
            double value = Evaluate(poly, points[i].X);
            polys[i] = ScalarDivide(poly, value);
        }

        double[] sum = new double[] { 0.0 };
        for (int i = 0; i < points.Length; i++)
        {
            polys[i] = ScalarMultiply(polys[i], points[i].Y);
            sum = Add(sum, polys[i]);
        }
        return sum;
    }

    // A double[] is used to represents a Polynomial
    // with its coefficients reversed compared to the standard mathematical notation.
    // For example, the polynomial 3x^2 + 2x + 1 is represented by the array [1, 2, 3].
    private static double[] Add(double[] one, double[] two)
    {
        double[] sum = new double[Math.Max(one.Length, two.Length)];
        Array.Copy(one, sum, one.Length);
        for (int i = 0; i < two.Length; i++)
        {
            sum[i] += two[i];
        }
        return sum;
    }

    private static double[] Multiply(double[] one, double[] two)
    {
        double[] product = new double[one.Length + two.Length - 1];
        for (int i = 0; i < one.Length; i++)
        {
            for (int j = 0; j < two.Length; j++)
            {
                product[i + j] += one[i] * two[j];
            }
        }
        return product;
    }

    private static double[] ScalarMultiply(double[] array, double value)
    {
        return array.Select(d => d * value).ToArray();
    }

    private static double[] ScalarDivide(double[] array, double value)
    {
        return ScalarMultiply(array, 1.0 / value);
    }

    private static double Evaluate(double[] array, double value)
    {
        double result = 0.0;
        for (int i = array.Length - 1; i >= 0; i--)
        {
            result = result * value + array[i];
        }
        return result;
    }

    private static void Display(double[] array)
    {
        int degree = array.Length - 1;
        if (degree == 0)
        {
            Console.WriteLine($"{array[0]:F5}");
            return;
        }

        for (int i = degree; i >= 0; i--)
        {
            if (array[i] == 0.0)
            {
                continue;
            }
            string sign = (array[i] < 0.0 && i == degree) ?
                "-" : (array[i] < 0.0) ? " - " : (i < degree) ? " + " : "";
            Console.Write(sign);
            double coeff = Math.Abs(array[i]);
            if (coeff > 1.0)
            {
                Console.Write($"{coeff:F5}");
            }
            string term = (i > 1) ? $"x^{i}" : (i == 1) ?
                "x" : (coeff == 1.0) ? "1" : "";
            Console.Write(term);
        }
        Console.WriteLine();
    }
}
