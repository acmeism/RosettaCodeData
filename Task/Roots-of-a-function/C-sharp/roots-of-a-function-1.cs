using System;

class Program
{
    public static void Main(string[] args)
    {
        Func<double, double> f = x => { return x * x * x - 3 * x * x + 2 * x; };

        double step = 0.001; // Smaller step values produce more accurate and precise results
        double start = -1;
        double stop = 3;
        double value = f(start);
        int sign = (value > 0) ? 1 : 0;

        // Check for root at start
        if (value == 0)
            Console.WriteLine("Root found at {0}", start);

        for (var x = start + step; x <= stop; x += step)
        {
            value = f(x);

            if (((value > 0) ? 1 : 0) != sign)
                // We passed a root
                Console.WriteLine("Root found near {0}", x);
            else if (value == 0)
                // We hit a root
                Console.WriteLine("Root found at {0}", x);

            // Update our sign
            sign = (value > 0) ? 1 : 0;
        }
    }
}
