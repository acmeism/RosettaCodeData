using System;

class Program
{
    private static int Sign(double x)
    {
        return x < 0.0 ? -1 : x > 0.0 ? 1 : 0;
    }

    public static void PrintRoots(Func<double, double> f, double lowerBound,
        double upperBound, double step)
    {
        double x = lowerBound, ox = x;
        double y = f(x), oy = y;
        int s = Sign(y), os = s;

        for (; x <= upperBound; x += step)
        {
            s = Sign(y = f(x));
            if (s == 0)
            {
                Console.WriteLine(x);
            }
            else if (s != os)
            {
                var dx = x - ox;
                var dy = y - oy;
                var cx = x - dx * (y / dy);
                Console.WriteLine("~{0}", cx);
            }

            ox = x;
            oy = y;
            os = s;
        }
    }

    public static void Main(string[] args)
    {
        Func<double, double> f = x => { return x * x * x - 3 * x * x + 2 * x; };
        PrintRoots(f, -1.0, 4, 0.002);
    }
}
